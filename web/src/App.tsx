import { useState } from "react";
import { useNuiEvent } from "./hooks/useNuiEvent";
import { useSwipe } from "./hooks/useSwipe";
import { fetchNui } from "./utils/fetchNui";
import { SkillsSection } from "./components/SkillsSection";
import { QuestsSection } from "./components/QuestsSection";
import { StaffSection } from "./components/StaffSection";
import type { InitData } from "./types";

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
        <div>
            <div>
                <h1>Skills & Quests</h1>
                <button onClick={handleClose}>Chiudi</button>
                
                {currentSection !== 'staff' && (
                    <div>
                        <button 
                            onClick={() => setCurrentSection('skills')}
                            disabled={currentSection === 'skills'}
                        >
                            Skills
                        </button>
                        <button 
                            onClick={() => setCurrentSection('quests')}
                            disabled={currentSection === 'quests'}
                        >
                            Quest
                        </button>
                    </div>
                )}

                {isStaffer() && showStaffButton && currentSection !== 'staff' && (
                    <button onClick={() => setCurrentSection('staff')}>
                        Pannello Staff
                    </button>
                )}

                {currentSection === 'staff' && (
                    <button onClick={() => setCurrentSection('skills')}>
                        Torna al Menu Principale
                    </button>
                )}
            </div>

            <div>
                {currentSection === 'skills' && <SkillsSection data={data} />}
                {currentSection === 'quests' && <QuestsSection data={data} />}
                {currentSection === 'staff' && <StaffSection data={data} />}
            </div>
        </div>
    );
}

export default App;