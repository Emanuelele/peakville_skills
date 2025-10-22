import { useState } from 'react';
import { StaffActionsManager } from '../managers/StaffActionsManager';
import type { InitData } from '../../types';

interface StaffSectionProps {
    data: InitData;
}

type StaffTab = 'trees' | 'skills' | 'quests';

export const StaffSection = ({ data }: StaffSectionProps) => {
    const [activeTab, setActiveTab] = useState<StaffTab>('trees');

    const handleSuccess = () => {
        console.log('Operazione completata con successo');
    };

    console.log('StaffSection render - activeTab:', activeTab);
    console.log('StaffSection data:', data);

    return (
        <div className="staff-section">
            <div className="staff-header">
                <h2>Pannello Staff</h2>
            </div>

            <div className="tabs">
                <button 
                    className={`tab ${activeTab === 'trees' ? 'active' : ''}`}
                    onClick={() => {
                        console.log('Clicked trees tab');
                        setActiveTab('trees');
                    }}
                >
                    Alberi
                </button>
                <button 
                    className={`tab ${activeTab === 'skills' ? 'active' : ''}`}
                    onClick={() => {
                        console.log('Clicked skills tab');
                        setActiveTab('skills');
                    }}
                >
                    Skills
                </button>
                <button 
                    className={`tab ${activeTab === 'quests' ? 'active' : ''}`}
                    onClick={() => {
                        console.log('Clicked quests tab');
                        setActiveTab('quests');
                    }}
                >
                    Quest
                </button>
            </div>

            <div className="content">
                {activeTab === 'trees' && (
                    <StaffActionsManager
                        data={data}
                        entityType="tree"
                        onSuccess={handleSuccess}
                    />
                )}

                {activeTab === 'skills' && (
                    <StaffActionsManager
                        data={data}
                        entityType="skill"
                        onSuccess={handleSuccess}
                    />
                )}

                {activeTab === 'quests' && (
                    <StaffActionsManager
                        data={data}
                        entityType="quest"
                        onSuccess={handleSuccess}
                    />
                )}
            </div>
        </div>
    );
};