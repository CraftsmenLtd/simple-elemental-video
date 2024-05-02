import ApiConfig from "../services/ApiConfig";
import axios from "axios";

const sendScteMarker = async (marker, markerTime) => {

    return new Promise(async (resolve, reject) => {
        try {
            const config = await ApiConfig();
            config.method = "get";
            config.url += "/live/marker?scte_marker_id="+marker+"&ad_duration_in_sec="+markerTime
            const response = await axios(config);
            resolve(response.data);
        } catch (error) {
            reject(error.response.data);
        }
    });
};

export default sendScteMarker;
