import logging
import urllib.error
from typing import Dict, Optional

import m3u8


LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)


def _get_sub_manifest_url(origin_endpoint: str) -> Optional[str]:
    """Parse hls manifest and ge sub-manifest url

    :param origin_endpoint: origin endpoint url mediapackage
    :return sub manifest url if available and manifest parsed properly
    """
    try:
        manifest: m3u8.M3U8 = m3u8.load(origin_endpoint)
    except urllib.error.URLError as error:
        LOGGER.exception(
            "Invalid origin endpoint url: %s",
            origin_endpoint,
            exc_info=error
        )
        return None

    try:
        sub_manifest_url: str = manifest.playlists[0].absolute_uri
    except (AttributeError, IndexError, ValueError, TypeError) as error:
        LOGGER.exception(
            "Can not generate sub manifest url for %s",
            origin_endpoint,
            exc_info=error
        )
        return None

    return sub_manifest_url


def get_markers(monitoring_cache_url: str) -> Dict[str, int]:
    """Get markers with timestamp from hls sub-manifest

    :param monitoring_cache_url: Hls manifest url from monitoring cache
    :return markers map with multiple markers if available
    """
    sub_manifest_url: str = _get_sub_manifest_url(monitoring_cache_url)
    if not sub_manifest_url:
        return {}

    try:
        sub_manifest_playlist: m3u8.M3U8 = m3u8.load(sub_manifest_url)
    except urllib.error.URLError as error:
        LOGGER.exception(
            "Invalid sub-manifest url: %s",
            sub_manifest_url,
            exc_info=error
        )
        return {}

    markers: Dict[str, str] = {}
    for segment in sub_manifest_playlist.segments:
        for daterange in segment.dateranges:
            marker_id: str = daterange.id.split("-")[-1]
            markers[marker_id] = daterange.start_date

    return markers
