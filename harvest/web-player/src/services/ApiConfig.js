import Config from "../config";
const HARVESTER_API_URL = Config.HARVESTER_API_URL;
const HARVESTER_API_KEY = Config.HARVESTER_API_KEY;

const ApiConfig = async () => {
    return {
        url: HARVESTER_API_URL,
        headers: {
            "x-api-key": HARVESTER_API_KEY,
        },
    };
};

export default ApiConfig;
