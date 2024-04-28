import "./Home.css";

import React, { useState, useEffect, memo } from "react";
import { Container } from "react-grid-system";

import liveScreen from "../live";
import vodScreen from "../vod";

const MemoizedLive = memo(liveScreen);
const MemoizedVod = memo(vodScreen);

function Home() {
    var { eventId } = getParams();

    function getParams() {
        const searchParams = new URLSearchParams(window.location.search);
        let searchParamsDict = Object.fromEntries(searchParams.entries());
        const eventId = searchParamsDict["event_id"];
        return { eventId };
    }

    const handleTabClick = (tabIndex) => {
        setActiveTab(tabIndex);
    };

    const tabs = [
        {
            title: "Live",
            tab_url: "live",
            content: <MemoizedLive eventId={eventId} />,
        },
        {
            title: "Vod",
            tab_url: "vod",
            content: <MemoizedVod eventId={eventId} />,
        },
    ];

    const [activeTabUrl, setactiveTabUrl] = useState(window.location.hash.slice(1));
    const initialActiveTab = tabs.findIndex((tab) => tab.tab_url === activeTabUrl);
    const [activeTab, setActiveTab] = useState(initialActiveTab !== -1 ? initialActiveTab : 0);
    const [tabsLoaded, setTabsLoaded] = useState(Array(tabs.length).fill(false));

    const markTabLoaded = (tabIndex) => {
        setTabsLoaded((prevTabsLoaded) => {
            const newTabsLoaded = [...prevTabsLoaded];
            newTabsLoaded[tabIndex] = true;
            return newTabsLoaded;
        });
    };

    useEffect(() => {
        if (!tabsLoaded[activeTab]) {
            setactiveTabUrl(tabs[activeTab].tab_url);
            markTabLoaded(activeTab);
        }
    }, [activeTab, tabsLoaded]);
    return (
        <Container>
            <div className={`tab_manager_theme shadow mb-2 rounded mt-3`}>
                <div className="justify-content-center">
                    <ul className={`nav nav-tabs shadow-sm mb-2 rounded`}>
                        {tabs.map((tab, index) => (
                            <li
                                className={`nav-item ${activeTab === index ? "active" : ""}`}
                                key={index}
                            >
                                <div className="nav_item_div">
                                    <a
                                        className={`nav-link ${
                                            activeTab === index ? "active" : "not_active"
                                        }`}
                                        onClick={() => handleTabClick(index)}
                                        href={`#${tab.tab_url}`}
                                    >
                                        {tab.title}
                                    </a>
                                </div>
                            </li>
                        ))}
                    </ul>
                    <div className="tab-content pt-2 tab_content">
                        {tabs.map((tab, index) => (
                            <div
                                className={`tab-pane fade ${
                                    activeTab === index ? "show active" : ""
                                }`}
                                key={index}
                            >
                                {tabsLoaded[index] ? tab.content : null}
                            </div>
                        ))}
                    </div>
                </div>
            </div>
        </Container>
    );
}

export default Home;
