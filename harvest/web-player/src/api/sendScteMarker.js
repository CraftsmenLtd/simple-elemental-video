import ApiConfig from "../services/ApiConfig";
import axios from "axios";

const sendScteMarker = async (marker, markerTime) => {
    try {
        const config = await ApiConfig();
        let data = JSON.stringify({
            "scte_marker_id": marker,
            "ad_duration_in_sec": markerTime
        });
        config.url += "/live/marker"
        config.method = 'post'
        config.data = data
        config.headers = {
            'Content-Type': 'application/json'
        }

        axios.request(config)
            .then((response) => {
                console.log(JSON.stringify(response.data));
                return response.data;
            })
            .catch((error) => {
                console.log(error);
                return error
            });
    } catch (error) {
        return error.message;
    }
};

export default sendScteMarker;
