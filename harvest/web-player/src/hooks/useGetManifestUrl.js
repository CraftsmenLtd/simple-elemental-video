import { useState, useEffect } from "react";
import ApiConfig from "../services/ApiConfig";
import axios from "axios";


const GetLiveManifestUrl = (eventId) => {
    return new Promise(async (resolve, reject) => {
        try {
            const config = await ApiConfig();
            config.method = "get";
            config.url += "/live/manifest"
            const response = await axios(config);
            resolve(response.data);
        } catch (error) {
            reject(error.response.data);
        }
    });
};

const GetVodManifestUrl = (eventId) => {
    return new Promise(async (resolve, reject) => {
        try {
            const config = await ApiConfig();
            config.method = "get";
            config.url += "/vod/manifest"
            const response = await axios(config);
            resolve(response.data);
        } catch (error) {
            reject(error.response.data);
        }
    });
};

const useGetManifestUrl = (eventId, manifestType) => {
    const [error, setError] = useState(null);
    const [isLoaded, setIsLoaded] = useState(false);
    const [isRefetching, setIsRefetching] = useState(false);
    const [manifestUrl, setManifestUrl] = useState(null);

    const refetchManifestUrl = async () => {
        setIsRefetching(true);
        try {
            await getManifestUrl();
            setIsRefetching(false);
        } catch (error) {
            setError(error);
        }
    };

    useEffect(() => {
        const GetEvent = async () => {
            try {
                await getManifestUrl();
            } catch (error) {
                setError(error);
            }
        };

        GetEvent();
    }, []);

    async function getManifestUrl() {
        let response = "";
        if (manifestType == "live") {
            response = await GetLiveManifestUrl(eventId);
        } else {
            response = await GetVodManifestUrl(eventId);
        }

        let manifest = response["endpoint"];
        setIsLoaded(true);
        setManifestUrl(manifest);
    }

    return { manifestUrl, error, isLoaded, refetchManifestUrl, isRefetching };
};

export default useGetManifestUrl;
