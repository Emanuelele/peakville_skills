import { useState, useEffect } from 'react';
import { Input } from '../elements/Input';
import { Button } from '../elements/Button';
import { ActionConfigBuilder } from '../managers/ActionConfigBuilder';
import { validateQuestData } from '../../utils/validation';
import type { Quest, Skill } from '../../types';

interface QuestFormProps {
  quest?: Quest;
  skills: Record<string, Skill>;
  quests: Record<string, Quest>;
  availableActions: Record<string, {
    label: string;
    category: string;
    parameters?: Record<string, { type: string; required: boolean }>;
  }>;
  onSubmit: (data: Partial<Quest>) => Promise<boolean>;
  onCancel: () => void;
}

export const QuestForm = ({ quest, skills, quests, availableActions, onSubmit, onCancel }: QuestFormProps) => {
  const [formData, setFormData] = useState({
    name: quest?.name || '',
    description: quest?.description || '',
    XP: quest?.XP || 100,
    steps: quest?.steps || 1,
    skillsReference: quest?.skillsReference || [],
    requiredQuests: quest?.requiredQuests || [],
    actionConfig: quest?.actionConfig || {},
    hidden: quest?.hidden || false,
  });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    if (quest) {
      setFormData({
        name: quest.name,
        description: quest.description,
        XP: quest.XP,
        steps: quest.steps,
        skillsReference: quest.skillsReference,
        requiredQuests: quest.requiredQuests,
        actionConfig: quest.actionConfig,
        hidden: quest.hidden,
      });
    }
  }, [quest]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    const validation = validateQuestData(formData);
    if (!validation.valid) {
      const errorMap: Record<string, string> = {};
      validation.errors.forEach(error => {
        if (error.includes('nome')) errorMap.name = error;
        if (error.includes('XP')) errorMap.XP = error;
        if (error.includes('steps')) errorMap.steps = error;
      });
      setErrors(errorMap);
      return;
    }

    setIsSubmitting(true);
    setErrors({});

    const success = await onSubmit(formData);
    
    setIsSubmitting(false);
    
    if (success) {
      setFormData({ 
        name: '', 
        description: '', 
        XP: 100, 
        steps: 1,
        skillsReference: [],
        requiredQuests: [],
        actionConfig: {},
        hidden: false
      });
    }
  };

  const toggleSkillReference = (skillId: string) => {
    setFormData({
      ...formData,
      skillsReference: formData.skillsReference.includes(skillId)
        ? formData.skillsReference.filter(id => id !== skillId)
        : [...formData.skillsReference, skillId]
    });
  };

  const toggleRequiredQuest = (questId: string) => {
    setFormData({
      ...formData,
      requiredQuests: formData.requiredQuests.includes(questId)
        ? formData.requiredQuests.filter(id => id !== questId)
        : [...formData.requiredQuests, questId]
    });
  };

  const availableQuests = Object.values(quests).filter(q => q.id !== quest?.id);

  return (
    <form onSubmit={handleSubmit} className="form">
      <Input
        label="Nome Quest"
        value={formData.name}
        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
        error={errors.name}
        required
        maxLength={100}
      />

      <div className="input-group">
        <label className="input-label">Descrizione</label>
        <textarea
          className="input textarea"
          value={formData.description}
          onChange={(e) => setFormData({ ...formData, description: e.target.value })}
          rows={4}
        />
      </div>

      <Input
        label="XP Ricompensa"
        type="number"
        value={formData.XP}
        onChange={(e) => setFormData({ ...formData, XP: parseInt(e.target.value) || 1 })}
        error={errors.XP}
        required
        min={1}
      />

      <Input
        label="Steps Richiesti"
        type="number"
        value={formData.steps}
        onChange={(e) => setFormData({ ...formData, steps: parseInt(e.target.value) || 1 })}
        error={errors.steps}
        required
        min={1}
      />

      <div className="input-group">
        <label className="checkbox-label">
          <input
            type="checkbox"
            checked={formData.hidden}
            onChange={(e) => setFormData({ ...formData, hidden: e.target.checked })}
          />
          Quest Nascosta
        </label>
      </div>

      {Object.keys(skills).length > 0 && (
        <div className="input-group">
          <label className="input-label">Skill Necessarie</label>
          <div className="checkbox-group scrollable">
            {Object.values(skills).map(skill => (
              <label key={skill.id} className="checkbox-label">
                <input
                  type="checkbox"
                  checked={formData.skillsReference.includes(skill.id)}
                  onChange={() => toggleSkillReference(skill.id)}
                />
                {skill.name}
              </label>
            ))}
          </div>
        </div>
      )}

      {availableQuests.length > 0 && (
        <div className="input-group">
          <label className="input-label">Quest Prerequisiti</label>
          <div className="checkbox-group scrollable">
            {availableQuests.map(q => (
              <label key={q.id} className="checkbox-label">
                <input
                  type="checkbox"
                  checked={formData.requiredQuests.includes(q.id)}
                  onChange={() => toggleRequiredQuest(q.id)}
                />
                {q.name}
              </label>
            ))}
          </div>
        </div>
      )}

      <div className="input-group">
        <label className="input-label">Configurazione Azione</label>
        <ActionConfigBuilder
          value={formData.actionConfig}
          onChange={(config) => setFormData({ ...formData, actionConfig: config })}
          availableActions={availableActions}
        />
      </div>

      <div className="form-actions">
        <Button type="submit" variant="primary" disabled={isSubmitting}>
          {isSubmitting ? 'Salvataggio...' : quest ? 'Aggiorna' : 'Crea'}
        </Button>
        <Button type="button" variant="error" onClick={onCancel} disabled={isSubmitting}>
          Annulla
        </Button>
      </div>
    </form>
  );
};