import { useState, useEffect } from 'react';
import { Button } from '../elements/Button';
import { Input } from '../elements/Input';
import { Alert } from '../elements/Alert';
import { useAlert } from '../../hooks/useAlert';
import { fetchNui } from '../../utils/fetchNui';
import type { InitData } from '../../types';

interface OnlinePlayer {
  source: number;
  identifier: string;
  name: string;
}

interface PlayerData {
  level: number;
  XP: number;
  tokens: number;
  currentTrees: Record<string, boolean>;
  skills: Record<string, boolean>;
  maxActiveQuests: number;
  activeQuests: Record<string, boolean>;
  quests: Record<string, any>;
}

interface PlayerManagementProps {
  data: InitData;
}

export const PlayerManagement = ({ data }: PlayerManagementProps) => {
  const [onlinePlayers, setOnlinePlayers] = useState<Record<string, OnlinePlayer>>({});
  const [selectedPlayer, setSelectedPlayer] = useState<number | null>(null);
  const [playerData, setPlayerData] = useState<PlayerData | null>(null);
  const [loading, setLoading] = useState(false);
  const { isOpen, config, showAlert, closeAlert } = useAlert();

  const [selectedSkills, setSelectedSkills] = useState<string[]>([]);
  const [selectedTrees, setSelectedTrees] = useState<string[]>([]);
  const [xpAmount, setXpAmount] = useState<number>(0);
  const [tokenAmount, setTokenAmount] = useState<number>(0);
  const [levelAmount, setLevelAmount] = useState<number>(1);
  const [questSteps, setQuestSteps] = useState<Record<string, number>>({});

  useEffect(() => {
    loadOnlinePlayers();
  }, []);

  const loadOnlinePlayers = async () => {
    try {
      const players = await fetchNui<Record<string, OnlinePlayer>>('getOnlinePlayers');
      setOnlinePlayers(players);
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: 'Impossibile caricare i player online',
        type: 'error'
      });
    }
  };

  const loadPlayerData = async (source: number) => {
    setLoading(true);
    try {
      const data = await fetchNui<PlayerData>('getPlayerData', source);
      setPlayerData(data);
      setSelectedPlayer(source);
      setLevelAmount(data.level);
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: 'Impossibile caricare i dati del player',
        type: 'error'
      });
    } finally {
      setLoading(false);
    }
  };

  const handleAddSkills = async () => {
    if (!selectedPlayer || selectedSkills.length === 0) return;
    
    setLoading(true);
    let successCount = 0;
    
    for (const skillId of selectedSkills) {
      try {
        const success = await fetchNui<boolean>('addPlayerSkill', {
          targetSource: selectedPlayer,
          skillId
        });
        if (success) successCount++;
      } catch (error) {
        console.error('Errore aggiunta skill:', error);
      }
    }
    
    setLoading(false);
    setSelectedSkills([]);
    await loadPlayerData(selectedPlayer);
    
    showAlert({
      title: 'Completato',
      message: `${successCount} skill aggiunte su ${selectedSkills.length}`,
      type: successCount === selectedSkills.length ? 'success' : 'warning'
    });
  };

  const handleRemoveSkills = async () => {
    if (!selectedPlayer || selectedSkills.length === 0) return;
    
    setLoading(true);
    let successCount = 0;
    
    for (const skillId of selectedSkills) {
      try {
        const success = await fetchNui<boolean>('removePlayerSkill', {
          targetSource: selectedPlayer,
          skillId
        });
        if (success) successCount++;
      } catch (error) {
        console.error('Errore rimozione skill:', error);
      }
    }
    
    setLoading(false);
    setSelectedSkills([]);
    await loadPlayerData(selectedPlayer);
    
    showAlert({
      title: 'Completato',
      message: `${successCount} skill rimosse su ${selectedSkills.length}`,
      type: successCount === selectedSkills.length ? 'success' : 'warning'
    });
  };

  const handleAddTrees = async () => {
    if (!selectedPlayer || selectedTrees.length === 0) return;
    
    setLoading(true);
    let successCount = 0;
    
    for (const treeId of selectedTrees) {
      try {
        const success = await fetchNui<boolean>('addPlayerTree', {
          targetSource: selectedPlayer,
          treeId
        });
        if (success) successCount++;
      } catch (error) {
        console.error('Errore aggiunta albero:', error);
      }
    }
    
    setLoading(false);
    setSelectedTrees([]);
    await loadPlayerData(selectedPlayer);
    
    showAlert({
      title: 'Completato',
      message: `${successCount} alberi aggiunti su ${selectedTrees.length}`,
      type: successCount === selectedTrees.length ? 'success' : 'warning'
    });
  };

  const handleRemoveTrees = async () => {
    if (!selectedPlayer || selectedTrees.length === 0) return;
    
    setLoading(true);
    let successCount = 0;
    
    for (const treeId of selectedTrees) {
      try {
        const success = await fetchNui<boolean>('removePlayerTree', {
          targetSource: selectedPlayer,
          treeId
        });
        if (success) successCount++;
      } catch (error) {
        console.error('Errore rimozione albero:', error);
      }
    }
    
    setLoading(false);
    setSelectedTrees([]);
    await loadPlayerData(selectedPlayer);
    
    showAlert({
      title: 'Completato',
      message: `${successCount} alberi rimossi su ${selectedTrees.length}`,
      type: successCount === selectedTrees.length ? 'success' : 'warning'
    });
  };

  const handleSetXP = async () => {
    if (!selectedPlayer || xpAmount < 0) return;
    
    setLoading(true);
    try {
      const success = await fetchNui<boolean>('setPlayerXP', {
        targetSource: selectedPlayer,
        amount: xpAmount
      });
      
      await loadPlayerData(selectedPlayer);
      showAlert({
        title: success ? 'Successo' : 'Errore',
        message: success ? 'XP impostato' : 'Impossibile impostare XP',
        type: success ? 'success' : 'error'
      });
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: 'Errore durante l\'operazione',
        type: 'error'
      });
    } finally {
      setLoading(false);
    }
  };

  const handleAddXP = async () => {
    if (!selectedPlayer || xpAmount <= 0) return;
    
    setLoading(true);
    try {
      const success = await fetchNui<boolean>('addPlayerXP', {
        targetSource: selectedPlayer,
        amount: xpAmount
      });
      
      await loadPlayerData(selectedPlayer);
      showAlert({
        title: success ? 'Successo' : 'Errore',
        message: success ? 'XP aggiunto' : 'Impossibile aggiungere XP',
        type: success ? 'success' : 'error'
      });
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: 'Errore durante l\'operazione',
        type: 'error'
      });
    } finally {
      setLoading(false);
    }
  };

  const handleRemoveXP = async () => {
    if (!selectedPlayer || xpAmount <= 0) return;
    
    setLoading(true);
    try {
      const success = await fetchNui<boolean>('removePlayerXP', {
        targetSource: selectedPlayer,
        amount: xpAmount
      });
      
      await loadPlayerData(selectedPlayer);
      showAlert({
        title: success ? 'Successo' : 'Errore',
        message: success ? 'XP rimosso' : 'Impossibile rimuovere XP',
        type: success ? 'success' : 'error'
      });
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: 'Errore durante l\'operazione',
        type: 'error'
      });
    } finally {
      setLoading(false);
    }
  };

  const handleSetTokens = async () => {
    if (!selectedPlayer || tokenAmount < 0) return;
    
    setLoading(true);
    try {
      const success = await fetchNui<boolean>('setPlayerTokens', {
        targetSource: selectedPlayer,
        amount: tokenAmount
      });
      
      await loadPlayerData(selectedPlayer);
      showAlert({
        title: success ? 'Successo' : 'Errore',
        message: success ? 'Token impostati' : 'Impossibile impostare token',
        type: success ? 'success' : 'error'
      });
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: 'Errore durante l\'operazione',
        type: 'error'
      });
    } finally {
      setLoading(false);
    }
  };

  const handleAddTokens = async () => {
    if (!selectedPlayer || tokenAmount <= 0) return;
    
    setLoading(true);
    try {
      const success = await fetchNui<boolean>('addPlayerTokens', {
        targetSource: selectedPlayer,
        amount: tokenAmount
      });
      
      await loadPlayerData(selectedPlayer);
      showAlert({
        title: success ? 'Successo' : 'Errore',
        message: success ? 'Token aggiunti' : 'Impossibile aggiungere token',
        type: success ? 'success' : 'error'
      });
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: 'Errore durante l\'operazione',
        type: 'error'
      });
    } finally {
      setLoading(false);
    }
  };

  const handleRemoveTokens = async () => {
    if (!selectedPlayer || tokenAmount <= 0) return;
    
    setLoading(true);
    try {
      const success = await fetchNui<boolean>('removePlayerTokens', {
        targetSource: selectedPlayer,
        amount: tokenAmount
      });
      
      await loadPlayerData(selectedPlayer);
      showAlert({
        title: success ? 'Successo' : 'Errore',
        message: success ? 'Token rimossi' : 'Impossibile rimuovere token',
        type: success ? 'success' : 'error'
      });
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: 'Errore durante l\'operazione',
        type: 'error'
      });
    } finally {
      setLoading(false);
    }
  };

  const handleSetLevel = async () => {
    if (!selectedPlayer || levelAmount < 1) return;
    
    setLoading(true);
    try {
      const success = await fetchNui<boolean>('setPlayerLevel', {
        targetSource: selectedPlayer,
        level: levelAmount
      });
      
      await loadPlayerData(selectedPlayer);
      showAlert({
        title: success ? 'Successo' : 'Errore',
        message: success ? 'Livello impostato' : 'Impossibile impostare livello',
        type: success ? 'success' : 'error'
      });
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: 'Errore durante l\'operazione',
        type: 'error'
      });
    } finally {
      setLoading(false);
    }
  };

  const handleSetQuestSteps = async (questId: string) => {
    if (!selectedPlayer || !questSteps[questId]) return;
    
    setLoading(true);
    try {
      const success = await fetchNui<boolean>('setPlayerQuestSteps', {
        targetSource: selectedPlayer,
        questId,
        steps: questSteps[questId]
      });
      
      await loadPlayerData(selectedPlayer);
      showAlert({
        title: success ? 'Successo' : 'Errore',
        message: success ? 'Steps impostati' : 'Impossibile impostare steps',
        type: success ? 'success' : 'error'
      });
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: 'Errore durante l\'operazione',
        type: 'error'
      });
    } finally {
      setLoading(false);
    }
  };

  const handleCompleteQuest = async (questId: string) => {
    if (!selectedPlayer) return;
    
    setLoading(true);
    try {
      const success = await fetchNui<boolean>('completePlayerQuest', {
        targetSource: selectedPlayer,
        questId
      });
      
      await loadPlayerData(selectedPlayer);
      showAlert({
        title: success ? 'Successo' : 'Errore',
        message: success ? 'Quest completata' : 'Impossibile completare quest',
        type: success ? 'success' : 'error'
      });
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: 'Errore durante l\'operazione',
        type: 'error'
      });
    } finally {
      setLoading(false);
    }
  };

  const handleUncompleteQuest = async (questId: string) => {
    if (!selectedPlayer) return;
    
    setLoading(true);
    try {
      const success = await fetchNui<boolean>('uncompletePlayerQuest', {
        targetSource: selectedPlayer,
        questId
      });
      
      await loadPlayerData(selectedPlayer);
      showAlert({
        title: success ? 'Successo' : 'Errore',
        message: success ? 'Quest ripristinata' : 'Impossibile ripristinare quest',
        type: success ? 'success' : 'error'
      });
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: 'Errore durante l\'operazione',
        type: 'error'
      });
    } finally {
      setLoading(false);
    }
  };

  const handleAssignHiddenQuest = async (questId: string) => {
    if (!selectedPlayer) return;
    
    setLoading(true);
    try {
      const success = await fetchNui<boolean>('assignHiddenQuest', {
        targetSource: selectedPlayer,
        questId
      });
      
      await loadPlayerData(selectedPlayer);
      showAlert({
        title: success ? 'Successo' : 'Errore',
        message: success ? 'Quest nascosta assegnata' : 'Impossibile assegnare quest',
        type: success ? 'success' : 'error'
      });
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: 'Errore durante l\'operazione',
        type: 'error'
      });
    } finally {
      setLoading(false);
    }
  };

  const toggleSkillSelection = (skillId: string) => {
    setSelectedSkills(prev => 
      prev.includes(skillId) 
        ? prev.filter(id => id !== skillId)
        : [...prev, skillId]
    );
  };

  const toggleTreeSelection = (treeId: string) => {
    setSelectedTrees(prev => 
      prev.includes(treeId) 
        ? prev.filter(id => id !== treeId)
        : [...prev, treeId]
    );
  };

  const availableSkills = Object.values(data.skills).filter(
    skill => !playerData?.skills[skill.id]
  );

  const ownedSkills = Object.values(data.skills).filter(
    skill => playerData?.skills[skill.id]
  );

  const availableTrees = Object.values(data.trees).filter(
    tree => !playerData?.currentTrees[tree.id]
  );

  const ownedTrees = Object.values(data.trees).filter(
    tree => playerData?.currentTrees[tree.id]
  );

  const hiddenQuests = Object.values(data.quests)
    .map(pq => pq.quest)
    .filter(quest => quest.hidden && !playerData?.quests[quest.id]);

  return (
    <div className="player-management">
      <div className="player-selector">
        <h3>Seleziona Player</h3>
        <div className="input-group">
          <select
            className="input"
            value={selectedPlayer || ''}
            onChange={(e) => {
              const source = parseInt(e.target.value);
              if (source) loadPlayerData(source);
            }}
          >
            <option value="">-- Seleziona un player --</option>
            {Object.values(onlinePlayers).map(player => (
              <option key={player.source} value={player.source}>
                {player.name} (ID: {player.source})
              </option>
            ))}
          </select>
        </div>

        <Button variant="primary" size="sm" onClick={loadOnlinePlayers} disabled={loading}>
          Aggiorna Lista
        </Button>
      </div>

      {playerData && selectedPlayer && (
        <>
          <div className="player-info-card">
            <h3>Dati Player: {onlinePlayers[selectedPlayer]?.name}</h3>
            <div className="player-stats-grid">
              <div className="player-stat-item">
                <div className="player-stat-label">Livello</div>
                <div className="player-stat-value">{playerData.level}</div>
              </div>
              <div className="player-stat-item">
                <div className="player-stat-label">XP</div>
                <div className="player-stat-value">{playerData.XP}</div>
              </div>
              <div className="player-stat-item">
                <div className="player-stat-label">Token</div>
                <div className="player-stat-value">{playerData.tokens}</div>
              </div>
              <div className="player-stat-item">
                <div className="player-stat-label">Alberi</div>
                <div className="player-stat-value">{Object.keys(playerData.currentTrees).length}</div>
              </div>
              <div className="player-stat-item">
                <div className="player-stat-label">Skills</div>
                <div className="player-stat-value">{Object.keys(playerData.skills).length}</div>
              </div>
            </div>
          </div>

          <div className="action-sections">
            <div className="action-section">
              <h4>Skills</h4>
              <div className="action-controls">
                {availableSkills.length > 0 && (
                  <>
                    <label className="input-label">Aggiungi Skills</label>
                    <div className="multi-select">
                      {availableSkills.map(skill => (
                        <div key={skill.id} className="multi-select-item">
                          <input
                            type="checkbox"
                            checked={selectedSkills.includes(skill.id)}
                            onChange={() => toggleSkillSelection(skill.id)}
                            id={`add-skill-${skill.id}`}
                          />
                          <label htmlFor={`add-skill-${skill.id}`}>{skill.name}</label>
                        </div>
                      ))}
                    </div>
                    <Button 
                      variant="success" 
                      onClick={handleAddSkills} 
                      disabled={loading || selectedSkills.length === 0}
                    >
                      Aggiungi Selezionate ({selectedSkills.length})
                    </Button>
                  </>
                )}

                {ownedSkills.length > 0 && (
                  <>
                    <label className="input-label">Rimuovi Skills</label>
                    <div className="multi-select">
                      {ownedSkills.map(skill => (
                        <div key={skill.id} className="multi-select-item">
                          <input
                            type="checkbox"
                            checked={selectedSkills.includes(skill.id)}
                            onChange={() => toggleSkillSelection(skill.id)}
                            id={`remove-skill-${skill.id}`}
                          />
                          <label htmlFor={`remove-skill-${skill.id}`}>{skill.name}</label>
                        </div>
                      ))}
                    </div>
                    <Button 
                      variant="error" 
                      onClick={handleRemoveSkills} 
                      disabled={loading || selectedSkills.length === 0}
                    >
                      Rimuovi Selezionate ({selectedSkills.length})
                    </Button>
                  </>
                )}
              </div>
            </div>

            <div className="action-section">
              <h4>Alberi</h4>
              <div className="action-controls">
                {availableTrees.length > 0 && (
                  <>
                    <label className="input-label">Aggiungi Alberi</label>
                    <div className="multi-select">
                      {availableTrees.map(tree => (
                        <div key={tree.id} className="multi-select-item">
                          <input
                            type="checkbox"
                            checked={selectedTrees.includes(tree.id)}
                            onChange={() => toggleTreeSelection(tree.id)}
                            id={`add-tree-${tree.id}`}
                          />
                          <label htmlFor={`add-tree-${tree.id}`}>{tree.name}</label>
                        </div>
                      ))}
                    </div>
                    <Button 
                      variant="success" 
                      onClick={handleAddTrees} 
                      disabled={loading || selectedTrees.length === 0}
                    >
                      Aggiungi Selezionati ({selectedTrees.length})
                    </Button>
                  </>
                )}

                {ownedTrees.length > 0 && (
                  <>
                    <label className="input-label">Rimuovi Alberi</label>
                    <div className="multi-select">
                      {ownedTrees.map(tree => (
                        <div key={tree.id} className="multi-select-item">
                          <input
                            type="checkbox"
                            checked={selectedTrees.includes(tree.id)}
                            onChange={() => toggleTreeSelection(tree.id)}
                            id={`remove-tree-${tree.id}`}
                          />
                          <label htmlFor={`remove-tree-${tree.id}`}>{tree.name}</label>
                        </div>
                      ))}
                    </div>
                    <Button 
                      variant="error" 
                      onClick={handleRemoveTrees} 
                      disabled={loading || selectedTrees.length === 0}
                    >
                      Rimuovi Selezionati ({selectedTrees.length})
                    </Button>
                  </>
                )}
              </div>
            </div>

            <div className="action-section">
              <h4>XP</h4>
              <div className="action-controls">
                <Input
                  type="number"
                  label="Quantità XP"
                  value={xpAmount}
                  onChange={(e) => setXpAmount(parseInt(e.target.value) || 0)}
                  min={0}
                />
                <div className="control-row">
                  <Button variant="primary" onClick={handleSetXP} disabled={loading}>
                    Imposta
                  </Button>
                  <Button variant="success" onClick={handleAddXP} disabled={loading}>
                    Aggiungi
                  </Button>
                  <Button variant="error" onClick={handleRemoveXP} disabled={loading}>
                    Rimuovi
                  </Button>
                </div>
              </div>
            </div>

            <div className="action-section">
              <h4>Token</h4>
              <div className="action-controls">
                <Input
                  type="number"
                  label="Quantità Token"
                  value={tokenAmount}
                  onChange={(e) => setTokenAmount(parseInt(e.target.value) || 0)}
                  min={0}
                />
                <div className="control-row">
                  <Button variant="primary" onClick={handleSetTokens} disabled={loading}>
                    Imposta
                  </Button>
                  <Button variant="success" onClick={handleAddTokens} disabled={loading}>
                    Aggiungi
                  </Button>
                  <Button variant="error" onClick={handleRemoveTokens} disabled={loading}>
                    Rimuovi
                  </Button>
                </div>
              </div>
            </div>

            <div className="action-section">
              <h4>Livello</h4>
              <div className="action-controls">
                <Input
                  type="number"
                  label="Livello"
                  value={levelAmount}
                  onChange={(e) => setLevelAmount(parseInt(e.target.value) || 1)}
                  min={1}
                  max={50}
                />
                <Button variant="primary" onClick={handleSetLevel} disabled={loading}>
                  Imposta Livello
                </Button>
              </div>
            </div>

            <div className="action-section">
              <h4>Quest</h4>
              <div className="action-controls">
                {Object.entries(playerData.quests).map(([questId, questData]) => (
                  <div key={questId} style={{ borderBottom: '1px solid rgba(255,255,255,0.1)', paddingBottom: '12px', marginBottom: '12px' }}>
                    <label className="input-label">{questData.quest.name}</label>
                    <div className="control-row">
                      <Input
                        type="number"
                        placeholder="Steps"
                        value={questSteps[questId] || questData.currentStep}
                        onChange={(e) => setQuestSteps({ ...questSteps, [questId]: parseInt(e.target.value) || 0 })}
                        min={0}
                        max={questData.quest.steps}
                      />
                      <Button 
                        variant="primary" 
                        size="sm" 
                        onClick={() => handleSetQuestSteps(questId)}
                        disabled={loading}
                      >
                        Set
                      </Button>
                    </div>
                    <div className="control-row" style={{ marginTop: '8px' }}>
                      {!questData.completed ? (
                        <Button 
                          variant="success" 
                          size="sm" 
                          onClick={() => handleCompleteQuest(questId)}
                          disabled={loading}
                        >
                          Completa
                        </Button>
                      ) : (
                        <Button 
                          variant="warning" 
                          size="sm" 
                          onClick={() => handleUncompleteQuest(questId)}
                          disabled={loading}
                        >
                          Ripristina
                        </Button>
                      )}
                    </div>
                  </div>
                ))}

                {hiddenQuests.length > 0 && (
                  <>
                    <label className="input-label">Assegna Quest Nascoste</label>
                    {hiddenQuests.map(quest => (
                      <div key={quest.id} className="control-row">
                        <span style={{ flex: 1, color: 'rgba(255,255,255,0.8)' }}>{quest.name}</span>
                        <Button 
                          variant="primary" 
                          size="sm" 
                          onClick={() => handleAssignHiddenQuest(quest.id)}
                          disabled={loading}
                        >
                          Assegna
                        </Button>
                      </div>
                    ))}
                  </>
                )}
              </div>
            </div>
          </div>
        </>
      )}

      <Alert
        isOpen={isOpen}
        onClose={closeAlert}
        title={config.title}
        message={config.message}
        type={config.type}
      />
    </div>
  );
};