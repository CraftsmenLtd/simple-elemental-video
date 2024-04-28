import ApiConfig from "../services/ApiConfig";
import axios from "axios";

const sendScteMarker = async (eventId, marker, markerTime) => {
    try {
        // const config = await ApiConfig();
        // const response = await axios.post(config.url + "/live/marker", {
        //     event_id: eventId,
        //     marker: marker,
        //     markerTime: markerTime
        // });
        // return response.data;
        return {
            status: "success",
        };
    } catch (error) {
        return error.message;
    }
};

export default sendScteMarker;
