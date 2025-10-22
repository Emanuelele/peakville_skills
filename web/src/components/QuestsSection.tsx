import type { InitData, PlayerQuest } from '../types';
import { fetchNui } from '../utils/fetchNui';

interface QuestsSectionProps {
    data: InitData;
}

export const QuestsSection = ({ data }: QuestsSectionProps) => {
    const handleSelectQuest = async (questId: number) => {
        const success = await fetchNui<boolean>('selectQuest', questId);
        if (!success) {
            console.error('Impossibile selezionare la quest');
        }
    };

    const handleDeselectQuest = async (questId: number) => {
        const success = await fetchNui<boolean>('deselectQuest', questId);
        if (!success) {
            console.error('Impossibile deselezionare la quest');
        }
    };

    const getActiveQuestsCount = (): number => {
        return Object.keys(data.player.activeQuests).length;
    };

    const canSelectQuest = (): boolean => {
        return getActiveQuestsCount() < data.player.maxActiveQuests;
    };

    const getQuestProgress = (playerQuest: PlayerQuest): number => {
        if (playerQuest.completed) return 100;
        return Math.floor((playerQuest.currentStep / playerQuest.quest.steps) * 100);
    };

    const activeQuests = Object.entries(data.quests)
        .filter(([questId]) => data.player.activeQuests[parseInt(questId)])
        .map(([, playerQuest]) => playerQuest);

    const availableQuests = Object.entries(data.quests)
        .filter(([questId]) => !data.player.activeQuests[parseInt(questId)] && !data.quests[parseInt(questId)].completed)
        .map(([, playerQuest]) => playerQuest);

    const completedQuests = Object.values(data.quests)
        .filter(playerQuest => playerQuest.completed);

    return (
        <div>
            <h2>Gestione Quest</h2>

            <div>
                <h3>Statistiche Player</h3>
                <p>Livello: {data.player.level}</p>
                <p>XP: {data.player.XP}</p>
                <p>Quest Attive: {getActiveQuestsCount()} / {data.player.maxActiveQuests}</p>
                <p>Quest Completate: {completedQuests.length}</p>
            </div>

            <div>
                <h3>Quest Attive</h3>
                {activeQuests.length === 0 ? (
                    <p>Nessuna quest attiva</p>
                ) : (
                    activeQuests.map((playerQuest: PlayerQuest) => (
                        <div key={playerQuest.quest.id}>
                            <h4>{playerQuest.quest.name}</h4>
                            <p>{playerQuest.quest.description}</p>
                            <p>Ricompensa XP: {playerQuest.quest.XP}</p>
                            <p>
                                Progresso: {playerQuest.currentStep} / {playerQuest.quest.steps} 
                                ({getQuestProgress(playerQuest)}%)
                            </p>
                            
                            {playerQuest.quest.skillsReference.length > 0 && (
                                <p>Skills associate: {playerQuest.quest.skillsReference.join(', ')}</p>
                            )}
                            
                            <button onClick={() => handleDeselectQuest(playerQuest.quest.id)}>
                                Deseleziona Quest
                            </button>
                        </div>
                    ))
                )}
            </div>

            <div>
                <h3>Quest Disponibili</h3>
                {!canSelectQuest() && (
                    <p>Hai raggiunto il numero massimo di quest attive</p>
                )}
                {availableQuests.length === 0 ? (
                    <p>Nessuna quest disponibile</p>
                ) : (
                    availableQuests.map((playerQuest: PlayerQuest) => (
                        <div key={playerQuest.quest.id}>
                            <h4>{playerQuest.quest.name}</h4>
                            <p>{playerQuest.quest.description}</p>
                            <p>Ricompensa XP: {playerQuest.quest.XP}</p>
                            <p>Steps richiesti: {playerQuest.quest.steps}</p>
                            
                            {playerQuest.quest.skillsReference.length > 0 && (
                                <p>Richiede skills: {playerQuest.quest.skillsReference.join(', ')}</p>
                            )}
                            
                            {playerQuest.quest.requiredQuests.length > 0 && (
                                <p>Richiede quest: {playerQuest.quest.requiredQuests.join(', ')}</p>
                            )}
                            
                            <button 
                                onClick={() => handleSelectQuest(playerQuest.quest.id)}
                                disabled={!canSelectQuest()}
                            >
                                Seleziona Quest
                            </button>
                        </div>
                    ))
                )}
            </div>

            <div>
                <h3>Quest Completate</h3>
                {completedQuests.length === 0 ? (
                    <p>Nessuna quest completata</p>
                ) : (
                    completedQuests.map((playerQuest: PlayerQuest) => (
                        <div key={playerQuest.quest.id}>
                            <h4>{playerQuest.quest.name}</h4>
                            <p>{playerQuest.quest.description}</p>
                            <p>XP ottenuto: {playerQuest.quest.XP}</p>
                        </div>
                    ))
                )}
            </div>
        </div>
    );
};