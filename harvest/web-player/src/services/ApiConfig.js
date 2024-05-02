import Config from "../config";
const HARVESTER_API_URL = Config.HARVESTER_API_URL;

const ApiConfig = async () => {
    return {
        url: HARVESTER_API_URL,
    };
};

export default ApiConfig;
