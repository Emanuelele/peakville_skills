import { useState } from 'react';
import { Modal } from '../elements/Modal';
import { Alert } from '../elements/Alert';
import { useAlert } from '../../hooks/useAlert';
import { TreeForm } from '../forms/TreeForm';
import { SkillForm } from '../forms/SkillForm';
import { QuestForm } from '../forms/QuestForm';
import { Button } from '../elements/Button';
import { fetchNui } from '../../utils/fetchNui';
import type { Tree, Skill, Quest, InitData } from '../../types';

interface StaffActionsManagerProps {
  data: InitData;
  entityType: 'tree' | 'skill' | 'quest';
  availableActions: Record<string, {
    label: string;
    category: string;
    parameters?: Record<string, { type: string; required: boolean }>;
  }>;
  onSuccess: () => void;
}

export const StaffActionsManagerUpdated = ({ data, entityType, availableActions, onSuccess }: StaffActionsManagerProps) => {
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const { isOpen, config, showAlert, closeAlert } = useAlert();

  const handleCreate = async (formData: Partial<Tree | Skill | Quest>): Promise<boolean> => {
    try {
      let success = false;
      
      if (entityType === 'tree') {
        success = await fetchNui<boolean>('createNewTree', formData);
      } else if (entityType === 'skill') {
        success = await fetchNui<boolean>('createNewSkill', formData);
      } else if (entityType === 'quest') {
        success = await fetchNui<boolean>('createNewQuest', formData);
      }

      if (success) {
        setIsCreateModalOpen(false);
        showAlert({
          title: 'Successo',
          message: `${getEntityTitle()} creato con successo`,
          type: 'success'
        });
        onSuccess();
      } else {
        showAlert({
          title: 'Errore',
          message: `Impossibile creare ${getEntityTitle().toLowerCase()}`,
          type: 'error'
        });
      }
      
      return success;
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: `Errore durante la creazione: ${error}`,
        type: 'error'
      });
      return false;
    }
  };

  const handleEdit = async (formData: Partial<Tree | Skill | Quest>): Promise<boolean> => {
    if (!selectedId) return false;

    try {
      let success = false;
      
      if (entityType === 'tree') {
        success = await fetchNui<boolean>('updateTree', { treeId: selectedId, data: formData });
      } else if (entityType === 'skill') {
        success = await fetchNui<boolean>('updateSkill', { skillId: selectedId, data: formData });
      } else if (entityType === 'quest') {
        success = await fetchNui<boolean>('updateQuest', { questId: selectedId, data: formData });
      }

      if (success) {
        setIsEditModalOpen(false);
        setSelectedId(null);
        showAlert({
          title: 'Successo',
          message: `${getEntityTitle()} modificato con successo`,
          type: 'success'
        });
        onSuccess();
      } else {
        showAlert({
          title: 'Errore',
          message: `Impossibile modificare ${getEntityTitle().toLowerCase()}`,
          type: 'error'
        });
      }
      
      return success;
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: `Errore durante la modifica: ${error}`,
        type: 'error'
      });
      return false;
    }
  };

  const handleDelete = async (id: string) => {
    showAlert({
      title: 'Conferma',
      message: 'Sei sicuro di voler eliminare questo elemento?',
      type: 'warning'
    });

    try {
      let success = false;
      
      if (entityType === 'tree') {
        success = await fetchNui<boolean>('deleteTree', id);
      } else if (entityType === 'skill') {
        success = await fetchNui<boolean>('deleteSkill', id);
      } else if (entityType === 'quest') {
        success = await fetchNui<boolean>('deleteQuest', id);
      }

      if (success) {
        showAlert({
          title: 'Successo',
          message: `${getEntityTitle()} eliminato con successo`,
          type: 'success'
        });
        onSuccess();
      } else {
        showAlert({
          title: 'Errore',
          message: `Impossibile eliminare ${getEntityTitle().toLowerCase()}`,
          type: 'error'
        });
      }
    } catch (error) {
      showAlert({
        title: 'Errore',
        message: `Errore durante l'eliminazione: ${error}`,
        type: 'error'
      });
    }
  };

  const openEditModal = (id: string) => {
    setSelectedId(id);
    setIsEditModalOpen(true);
  };

  const getSelectedEntity = (): Tree | Skill | Quest | undefined => {
    if (!selectedId) return undefined;
    
    if (entityType === 'tree') {
      return data.trees[selectedId];
    } else if (entityType === 'skill') {
      return data.skills[selectedId];
    } else if (entityType === 'quest') {
      return data.quests[selectedId]?.quest;
    }
  };

  const getEntityTitle = () => {
    if (entityType === 'tree') return 'Albero';
    if (entityType === 'skill') return 'Skill';
    return 'Quest';
  };

  return (
    <>
      <div className="staff-actions-manager">
        <div className="manager-header">
          <Button 
            variant="primary"
            onClick={() => setIsCreateModalOpen(true)}
          >
            Crea Nuovo {getEntityTitle()}
          </Button>
        </div>

        <div className="entities-list">
          {entityType === 'tree' && Object.values(data.trees).map((tree) => (
            <div key={tree.id} className="entity-item">
              <div className="entity-info">
                <h4>{tree.name}</h4>
                <p>{tree.description}</p>
                <span>Prezzo: {tree.price} token</span>
              </div>
              <div className="entity-actions">
                <Button 
                  size="sm"
                  variant="primary"
                  onClick={() => openEditModal(tree.id)}
                >
                  Modifica
                </Button>
                <Button 
                  size="sm"
                  variant="error"
                  onClick={() => handleDelete(tree.id)}
                >
                  Elimina
                </Button>
              </div>
            </div>
          ))}

          {entityType === 'skill' && Object.values(data.skills).map((skill) => (
            <div key={skill.id} className="entity-item">
              {skill.image && <img src={skill.image} alt={skill.name} className="entity-image" />}
              <div className="entity-info">
                <h4>{skill.name}</h4>
                <p>{skill.description}</p>
                <span>Prezzo: {skill.price} token</span>
                <span>Albero: {data.trees[skill.parentTree]?.name || 'N/A'}</span>
              </div>
              <div className="entity-actions">
                <Button 
                  size="sm"
                  variant="primary"
                  onClick={() => openEditModal(skill.id)}
                >
                  Modifica
                </Button>
                <Button 
                  size="sm"
                  variant="error"
                  onClick={() => handleDelete(skill.id)}
                >
                  Elimina
                </Button>
              </div>
            </div>
          ))}

          {entityType === 'quest' && Object.values(data.quests).map((playerQuest) => {
            const quest = playerQuest.quest;
            return (
              <div key={quest.id} className="entity-item">
                <div className="entity-info">
                  <h4>{quest.name}</h4>
                  <p>{quest.description}</p>
                  <span>XP: {quest.XP}</span>
                  <span>Steps: {quest.steps}</span>
                  {quest.hidden && <span className="badge-warning">Nascosta</span>}
                </div>
                <div className="entity-actions">
                  <Button 
                    size="sm"
                    variant="primary"
                    onClick={() => openEditModal(quest.id)}
                  >
                    Modifica
                  </Button>
                  <Button 
                    size="sm"
                    variant="error"
                    onClick={() => handleDelete(quest.id)}
                  >
                    Elimina
                  </Button>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {isCreateModalOpen && (
        <Modal
          isOpen={isCreateModalOpen}
          onClose={() => setIsCreateModalOpen(false)}
          title={`Crea ${getEntityTitle()}`}
        >
          {entityType === 'tree' && (
            <TreeForm
              onSubmit={handleCreate}
              onCancel={() => setIsCreateModalOpen(false)}
            />
          )}
          {entityType === 'skill' && (
            <SkillForm
              trees={data.trees}
              skills={data.skills}
              onSubmit={handleCreate}
              onCancel={() => setIsCreateModalOpen(false)}
            />
          )}
          {entityType === 'quest' && (
            <QuestForm
              skills={data.skills}
              quests={Object.fromEntries(
                Object.entries(data.quests).map(([id, pq]) => [id, pq.quest])
              )}
              availableActions={availableActions}
              onSubmit={handleCreate}
              onCancel={() => setIsCreateModalOpen(false)}
            />
          )}
        </Modal>
      )}

      {isEditModalOpen && (
        <Modal
          isOpen={isEditModalOpen}
          onClose={() => {
            setIsEditModalOpen(false);
            setSelectedId(null);
          }}
          title={`Modifica ${getEntityTitle()}`}
        >
          {entityType === 'tree' && (
            <TreeForm
              tree={getSelectedEntity() as Tree}
              onSubmit={handleEdit}
              onCancel={() => {
                setIsEditModalOpen(false);
                setSelectedId(null);
              }}
            />
          )}
          {entityType === 'skill' && (
            <SkillForm
              skill={getSelectedEntity() as Skill}
              trees={data.trees}
              skills={data.skills}
              onSubmit={handleEdit}
              onCancel={() => {
                setIsEditModalOpen(false);
                setSelectedId(null);
              }}
            />
          )}
          {entityType === 'quest' && (
            <QuestForm
              quest={getSelectedEntity() as Quest}
              skills={data.skills}
              quests={Object.fromEntries(
                Object.entries(data.quests).map(([id, pq]) => [id, pq.quest])
              )}
              availableActions={availableActions}
              onSubmit={handleEdit}
              onCancel={() => {
                setIsEditModalOpen(false);
                setSelectedId(null);
              }}
            />
          )}
        </Modal>
      )}

      <Alert
        isOpen={isOpen}
        onClose={closeAlert}
        title={config.title}
        message={config.message}
        type={config.type}
      />
    </>
  );
};