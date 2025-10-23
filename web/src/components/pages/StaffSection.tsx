import { useState } from 'react';
import { StaffActionsManager } from '../managers/StaffActionsManager';
import { PlayerManagement } from '../managers/PlayerManagement';
import type { InitData } from '../../types';

interface StaffSectionProps {
    data: InitData;
}

type StaffTab = 'players' | 'trees' | 'skills' | 'quests';

export const StaffSection = ({ data }: StaffSectionProps) => {
    const [activeTab, setActiveTab] = useState<StaffTab>('players');

    const handleSuccess = () => {
    };

    return (
        <div className="staff-section">
            <div className="staff-header">
                <h2>Pannello Staff</h2>
            </div>

            <div className="tabs">
                <button 
                    className={`tab ${activeTab === 'players' ? 'active' : ''}`}
                    onClick={() => setActiveTab('players')}
                >
                    Gestione Player
                </button>
                <button 
                    className={`tab ${activeTab === 'trees' ? 'active' : ''}`}
                    onClick={() => setActiveTab('trees')}
                >
                    Alberi
                </button>
                <button 
                    className={`tab ${activeTab === 'skills' ? 'active' : ''}`}
                    onClick={() => setActiveTab('skills')}
                >
                    Skills
                </button>
                <button 
                    className={`tab ${activeTab === 'quests' ? 'active' : ''}`}
                    onClick={() => setActiveTab('quests')}
                >
                    Quest
                </button>
            </div>

            <div className="content">
                {activeTab === 'players' && (
                    <PlayerManagement data={data} />
                )}

                {activeTab === 'trees' && (
                    <StaffActionsManager
                        data={data}
                        entityType="tree"
                        availableActions={data.availableActions}
                        onSuccess={handleSuccess}
                    />
                )}

                {activeTab === 'skills' && (
                    <StaffActionsManager
                        data={data}
                        entityType="skill"
                        availableActions={data.availableActions}
                        onSuccess={handleSuccess}
                    />
                )}

                {activeTab === 'quests' && (
                    <StaffActionsManager
                        data={data}
                        entityType="quest"
                        availableActions={data.availableActions}
                        onSuccess={handleSuccess}
                    />
                )}
            </div>
        </div>
    );
};