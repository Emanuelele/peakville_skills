import { useState } from "react";
import { useNuiEvent } from "./hooks/useNuiEvent";
import { fetchNui } from "./utils/fetchNui";
import type { InitData } from "./types";

function App() {
    const [visible, setVisible] = useState(false);
    const [data, setData] = useState<InitData | null>(null);

    useNuiEvent("setVisible", (isVisible: boolean) => {
        setVisible(isVisible);
    });

    useNuiEvent("init", (initData: InitData) => {
        setData(initData);
    });

    const handleClose = () => {
        setVisible(false);
        fetchNui("close");
    };

    if (!visible) return null;

    return (
        <div>
            <h1>Skills UI</h1>
            <button onClick={handleClose}>Chiudi</button>
            {data && (
                <div>
                    <p>Level: {data.player.level}</p>
                    <p>XP: {data.player.XP}</p>
                    <p>Tokens: {data.player.tokens}</p>
                </div>
            )}
        </div>
    );
}

export default App;
