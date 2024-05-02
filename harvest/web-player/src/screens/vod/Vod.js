import React, { useState } from "react";
import ReactHlsPlayer from "react-hls-player";
import { Container, Row, Col } from "react-grid-system";

import useGetManifestUrl from "../../hooks/useGetManifestUrl";

function Vod({ eventId }) {
    const { manifestUrl, error, isLoaded, refetchManifestUrl, isRefetching } = useGetManifestUrl(
        eventId,
        "vod"
    );

    if (!isLoaded) {
        return "Loading......";
    } else {
        return (
            <Container>
                <Row className="row justify-content-center">
                    <Row>
                        <Col>
                            <label className="m-2 my-4">Vod HLS Url:</label>
                            <label className="m-2 my-4">{manifestUrl}</label>
                        </Col>
                    </Row>
                    <Row>
                        <Col>
                            <ReactHlsPlayer
                                className="border border-3 border-info"
                                src={manifestUrl}
                                autoPlay={false}
                                controls={true}
                                width="auto"
                                height="500px"
                            />
                        </Col>
                    </Row>
                </Row>
            </Container>
        );
    }
}

export default Vod;
