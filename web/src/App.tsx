import { useState } from "react";
import { useNuiEvent } from "./hooks/useNuiEvent";
import { useSwipe } from "./hooks/useSwipe";
import { fetchNui } from "./utils/fetchNui";
import { SkillsSection } from "./components/pages/SkillsSection";
import { QuestsSection } from "./components/pages/QuestsSection";
import { StaffSection } from "./components/pages/StaffSection";
import type { InitData } from "./types";
import './App.css';

type Section = 'skills' | 'quests' | 'staff';

function App() {
    const [visible, setVisible] = useState(false);
    const [data, setData] = useState<InitData | null>(null);
    const [currentSection, setCurrentSection] = useState<Section>('skills');
    const [showStaffButton] = useState(true);

    useNuiEvent("setVisible", (isVisible: boolean) => {
        setVisible(isVisible);
        if (isVisible) {
            setCurrentSection('skills');
        }
    });

    useNuiEvent("init", (initData: InitData) => {
        setData(initData);
    });

    useSwipe({
        onSwipeLeft: () => {
            if (currentSection === 'skills') {
                setCurrentSection('quests');
            }
        },
        onSwipeRight: () => {
            if (currentSection === 'quests') {
                setCurrentSection('skills');
            }
        }
    });

    const handleClose = () => {
        setVisible(false);
        fetchNui("close");
    };

    const isStaffer = (): boolean => {
        return true;
    };

    if (!visible || !data) return null;

    return (
        <div className="app-container">
            <div className="header">
                <h1>Skills & Quests</h1>
                
                <div className="player-stats">
                    <span>
                        <span>Livello</span>
                        <strong>{data.player.level}</strong>
                    </span>
                    <span>
                        <span>XP</span>
                        <strong>{data.player.XP}</strong>
                    </span>
                    <span>
                        <span>Token</span>
                        <strong>{data.player.tokens}</strong>
                    </span>
                </div>

                <button className="close-btn" onClick={handleClose}>×</button>
            </div>
            
            {currentSection !== 'staff' && (
                <div className="tabs">
                    <button 
                        className={`tab ${currentSection === 'skills' ? 'active' : ''}`}
                        onClick={() => setCurrentSection('skills')}
                    >
                        Skills
                    </button>
                    <button 
                        className={`tab ${currentSection === 'quests' ? 'active' : ''}`}
                        onClick={() => setCurrentSection('quests')}
                    >
                        Quest
                    </button>
                    
                    {isStaffer() && showStaffButton && (
                        <button 
                            className="tab"
                            onClick={() => setCurrentSection('staff')}
                        >
                            Pannello Staff
                        </button>
                    )}
                </div>
            )}

            {currentSection === 'staff' && (
                <div className="tabs">
                    <button 
                        className="tab"
                        onClick={() => setCurrentSection('skills')}
                    >
                        ← Torna al Menu
                    </button>
                </div>
            )}

            <div className="content">
                {currentSection === 'skills' && <SkillsSection data={data} />}
                {currentSection === 'quests' && <QuestsSection data={data} />}
                {currentSection === 'staff' && <StaffSection data={data} />}
            </div>
        </div>
    );
}

export default App;