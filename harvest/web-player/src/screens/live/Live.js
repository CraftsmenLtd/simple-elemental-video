import React, { useState } from "react";
import ReactHlsPlayer from "@ducanh2912/react-hls-player";
import { Container, Row, Col } from "react-grid-system";

import useGetManifestUrl from "../../hooks/useGetManifestUrl";
import sendScteMarker from "../../api/sendScteMarker";

function Live({ eventId, isAdmin }) {
    const [markerTime, setMarkerTime] = useState("");
    const { manifestUrl, error, isLoaded, refetchManifestUrl, isRefetching } = useGetManifestUrl(
        eventId,
        "live"
    );

    function handleSendScteMarker(marker) {
        if (markerTime != "") {
            sendScteMarker(marker, markerTime);
        }
    }

    if (!isLoaded) {
        return "Loading......";
    } else {
        return (
            <Container>
                <Row className="row justify-content-center">
                    <Row>
                        <Col>
                            <label className="m-2 my-4 font-weight-bold">Live HLS Url:</label>
                            <label className="m-2 my-4">{manifestUrl}</label>
                        </Col>
                    </Row>
                    <Row>
                        {isAdmin == "true" &&
                            <Col>
                                <Row>
                                    <div>
                                        <label className="m-2 my-4 font-weight-bold">
                                            Select marker time
                                        </label>
                                        {/* <input
                                        type="datetime-local"
                                        value={markerTime}
                                        onChange={(e) => setMarkerTime(e.target.value)}
                                    /> */}
                                        <input
                                            type="text"
                                            value={markerTime}
                                            onChange={(e) => setMarkerTime(e.target.value)}
                                        />
                                    </div>
                                </Row>
                                <Row>
                                    <div className="flex-content">
                                        <label className="m-2 my-2 font-weight-bold">Send marker</label>
                                    </div>
                                    <div>
                                        <button
                                            className="btn btn-primary mx-2"
                                            onClick={() => handleSendScteMarker("505")}
                                        >
                                            Start Marker
                                        </button>
                                    </div>
                                    <div>
                                        <button
                                            className="btn btn-primary mx-2"
                                            onClick={() => handleSendScteMarker("305")}
                                        >
                                            End Marker
                                        </button>
                                    </div>
                                </Row>
                            </Col>
                        }
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

export default Live;
