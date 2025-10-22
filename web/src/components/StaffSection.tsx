import { useState } from 'react';
import type { InitData } from '../types';

interface StaffSectionProps {
    data: InitData;
}

type StaffTab = 'trees' | 'skills' | 'quests' | 'players';

export const StaffSection = ({ data }: StaffSectionProps) => {
    const [activeTab, setActiveTab] = useState<StaffTab>('trees');

    return (
        <div>
            <h2>Pannello Staff</h2>

            <div>
                <button onClick={() => setActiveTab('trees')}>Alberi</button>
                <button onClick={() => setActiveTab('skills')}>Skills</button>
                <button onClick={() => setActiveTab('quests')}>Quest</button>
                <button onClick={() => setActiveTab('players')}>Gestione Player</button>
            </div>

            {activeTab === 'trees' && (
                <div>
                    <h3>Gestione Alberi</h3>
                    <button>Crea Nuovo Albero</button>
                    
                    <div>
                        {Object.values(data.trees).map(tree => (
                            <div key={tree.id}>
                                <h4>{tree.name}</h4>
                                <p>{tree.description}</p>
                                <p>Prezzo: {tree.price}</p>
                                <button>Modifica</button>
                                <button>Elimina</button>
                            </div>
                        ))}
                    </div>
                </div>
            )}

            {activeTab === 'skills' && (
                <div>
                    <h3>Gestione Skills</h3>
                    <button>Crea Nuova Skill</button>
                    
                    <div>
                        {Object.values(data.skills).map(skill => (
                            <div key={skill.id}>
                                <h4>{skill.name}</h4>
                                <p>{skill.description}</p>
                                <p>Albero: {skill.parentTree}</p>
                                <p>Prezzo: {skill.price}</p>
                                <button>Modifica</button>
                                <button>Elimina</button>
                            </div>
                        ))}
                    </div>
                </div>
            )}

            {activeTab === 'quests' && (
                <div>
                    <h3>Gestione Quest</h3>
                    <button>Crea Nuova Quest</button>
                    
                    <div>
                        {Object.values(data.quests).map(playerQuest => {
                            const quest = playerQuest.quest;
                            return (
                                <div key={quest.id}>
                                    <h4>{quest.name}</h4>
                                    <p>{quest.description}</p>
                                    <p>XP: {quest.XP}</p>
                                    <p>Steps: {quest.steps}</p>
                                    <p>Hidden: {quest.hidden ? 'Sì' : 'No'}</p>
                                    <button>Modifica</button>
                                    <button>Elimina</button>
                                </div>
                            );
                        })}
                    </div>
                </div>
            )}

            {activeTab === 'players' && (
                <div>
                    <h3>Gestione Player</h3>
                    
                    <div>
                        <h4>Assegna Quest a Player</h4>
                        <p>Funzionalità da implementare</p>
                    </div>

                    <div>
                        <h4>Aggiungi XP a Player</h4>
                        <p>Funzionalità da implementare</p>
                    </div>

                    <div>
                        <h4>Aggiungi Skill a Player</h4>
                        <p>Funzionalità da implementare</p>
                    </div>

                    <div>
                        <h4>Aggiungi Token a Player</h4>
                        <p>Funzionalità da implementare</p>
                    </div>

                    <div>
                        <h4>Reset Progresso Player</h4>
                        <p>Funzionalità da implementare</p>
                    </div>
                </div>
            )}
        </div>
    );
};