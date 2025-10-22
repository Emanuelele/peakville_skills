import { Card } from '../elements/Card';
import { Button } from '../elements/Button';
import { formatPercentage } from '../../utils/formatters';
import type { InitData, PlayerQuest } from '../../types';
import { fetchNui } from '../../utils/fetchNui';

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

    const activeQuests = Object.entries(data.quests)
        .filter(([questId]) => data.player.activeQuests[parseInt(questId)])
        .map(([, playerQuest]) => playerQuest);

    const availableQuests = Object.entries(data.quests)
        .filter(([questId]) => !data.player.activeQuests[parseInt(questId)] && !data.quests[parseInt(questId)].completed)
        .map(([, playerQuest]) => playerQuest);

    const completedQuests = Object.values(data.quests)
        .filter(playerQuest => playerQuest.completed);

    return (
        <div className="quests-section">
            <div className="stats-panel">
                <div className="stat-item">
                    <span className="stat-label">Livello</span>
                    <span className="stat-value">{data.player.level}</span>
                </div>
                <div className="stat-item">
                    <span className="stat-label">XP</span>
                    <span className="stat-value">{data.player.XP}</span>
                </div>
                <div className="stat-item">
                    <span className="stat-label">Quest Attive</span>
                    <span className="stat-value">{getActiveQuestsCount()} / {data.player.maxActiveQuests}</span>
                </div>
                <div className="stat-item">
                    <span className="stat-label">Quest Completate</span>
                    <span className="stat-value">{completedQuests.length}</span>
                </div>
            </div>

            <div className="quests-container">
                <section className="quest-category">
                    <h3>Quest Attive</h3>
                    {activeQuests.length === 0 ? (
                        <p className="empty-message">Nessuna quest attiva</p>
                    ) : (
                        <div className="grid">
                            {activeQuests.map((playerQuest: PlayerQuest) => {
                                const progress = formatPercentage(playerQuest.currentStep, playerQuest.quest.steps);
                                
                                return (
                                    <Card
                                        key={playerQuest.quest.id}
                                        title={playerQuest.quest.name}
                                        footer={
                                            <Button
                                                variant="error"
                                                size="sm"
                                                onClick={() => handleDeselectQuest(playerQuest.quest.id)}
                                            >
                                                Deseleziona
                                            </Button>
                                        }
                                    >
                                        <p>{playerQuest.quest.description}</p>
                                        
                                        <div className="quest-info">
                                            <span>⭐ {playerQuest.quest.XP} XP</span>
                                        </div>

                                        <div className="progress-container">
                                            <div className="progress-bar">
                                                <div 
                                                    className="progress-fill" 
                                                    style={{ width: `${progress}%` }}
                                                />
                                            </div>
                                            <span className="progress-text">
                                                {playerQuest.currentStep} / {playerQuest.quest.steps} ({progress}%)
                                            </span>
                                        </div>

                                        {playerQuest.quest.skillsReference.length > 0 && (
                                            <div className="quest-requirements">
                                                <small>Skills: {playerQuest.quest.skillsReference.join(', ')}</small>
                                            </div>
                                        )}
                                    </Card>
                                );
                            })}
                        </div>
                    )}
                </section>

                <section className="quest-category">
                    <h3>Quest Disponibili</h3>
                    {!canSelectQuest() && (
                        <div className="warning-message">
                            Hai raggiunto il numero massimo di quest attive
                        </div>
                    )}
                    {availableQuests.length === 0 ? (
                        <p className="empty-message">Nessuna quest disponibile</p>
                    ) : (
                        <div className="grid">
                            {availableQuests.map((playerQuest: PlayerQuest) => (
                                <Card
                                    key={playerQuest.quest.id}
                                    title={playerQuest.quest.name}
                                    footer={
                                        <Button
                                            variant="primary"
                                            size="sm"
                                            onClick={() => handleSelectQuest(playerQuest.quest.id)}
                                            disabled={!canSelectQuest()}
                                        >
                                            Seleziona
                                        </Button>
                                    }
                                >
                                    <p>{playerQuest.quest.description}</p>
                                    
                                    <div className="quest-info">
                                        <span>⭐ {playerQuest.quest.XP} XP</span>
                                        <span>📊 {playerQuest.quest.steps} steps</span>
                                    </div>

                                    {playerQuest.quest.skillsReference.length > 0 && (
                                        <div className="quest-requirements">
                                            <small>Richiede skills: {playerQuest.quest.skillsReference.join(', ')}</small>
                                        </div>
                                    )}

                                    {playerQuest.quest.requiredQuests.length > 0 && (
                                        <div className="quest-requirements">
                                            <small>Richiede quest: {playerQuest.quest.requiredQuests.join(', ')}</small>
                                        </div>
                                    )}
                                </Card>
                            ))}
                        </div>
                    )}
                </section>

                <section className="quest-category">
                    <h3>Quest Completate</h3>
                    {completedQuests.length === 0 ? (
                        <p className="empty-message">Nessuna quest completata</p>
                    ) : (
                        <div className="grid">
                            {completedQuests.map((playerQuest: PlayerQuest) => (
                                <Card
                                    key={playerQuest.quest.id}
                                    title={playerQuest.quest.name}
                                >
                                    <p>{playerQuest.quest.description}</p>
                                    
                                    <div className="quest-info">
                                        <span className="completed">✓ Completata</span>
                                        <span>⭐ {playerQuest.quest.XP} XP</span>
                                    </div>
                                </Card>
                            ))}
                        </div>
                    )}
                </section>
            </div>
        </div>
    );
};