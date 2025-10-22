import { useState, useEffect } from 'react';
import { Input } from '../elements/Input';
import { Button } from '../elements/Button';
import { validateSkillData } from '../../utils/validation';
import type { Skill, Tree } from '../../types';

interface SkillFormProps {
  skill?: Skill;
  trees: Record<number, Tree>;
  skills: Record<number, Skill>;
  onSubmit: (data: Partial<Skill>) => Promise<boolean>;
  onCancel: () => void;
}

export const SkillForm = ({ skill, trees, skills, onSubmit, onCancel }: SkillFormProps) => {
  const [formData, setFormData] = useState({
    name: skill?.name || '',
    description: skill?.description || '',
    image: skill?.image || '',
    price: skill?.price || 1,
    parentTree: skill?.parentTree || 0,
    previousSkills: skill?.previousSkills || [],
    nextSkills: skill?.nextSkills || [],
  });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    if (skill) {
      setFormData({
        name: skill.name,
        description: skill.description,
        image: skill.image,
        price: skill.price,
        parentTree: skill.parentTree,
        previousSkills: skill.previousSkills,
        nextSkills: skill.nextSkills,
      });
    }
  }, [skill]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    const validation = validateSkillData(formData);
    if (!validation.valid) {
      const errorMap: Record<string, string> = {};
      validation.errors.forEach(error => {
        if (error.includes('nome')) errorMap.name = error;
        if (error.includes('prezzo')) errorMap.price = error;
        if (error.includes('albero')) errorMap.parentTree = error;
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
        image: '', 
        price: 1, 
        parentTree: 0,
        previousSkills: [],
        nextSkills: []
      });
    }
  };

  const togglePreviousSkill = (skillId: number) => {
    setFormData({
      ...formData,
      previousSkills: formData.previousSkills.includes(skillId)
        ? formData.previousSkills.filter(id => id !== skillId)
        : [...formData.previousSkills, skillId]
    });
  };

  const availableSkills = Object.values(skills)
    .filter(s => s.id !== skill?.id && s.parentTree === formData.parentTree);

  return (
    <form onSubmit={handleSubmit} className="form">
      <Input
        label="Nome Skill"
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
        label="URL Immagine"
        value={formData.image}
        onChange={(e) => setFormData({ ...formData, image: e.target.value })}
        placeholder="https://..."
      />

      <Input
        label="Prezzo (Token)"
        type="number"
        value={formData.price}
        onChange={(e) => setFormData({ ...formData, price: parseInt(e.target.value) || 1 })}
        error={errors.price}
        required
        min={1}
      />

      <div className="input-group">
        <label className="input-label">Albero Genitore</label>
        <select
          className="input"
          value={formData.parentTree}
          onChange={(e) => setFormData({ 
            ...formData, 
            parentTree: parseInt(e.target.value),
            previousSkills: []
          })}
          required
        >
          <option value={0}>Seleziona un albero</option>
          {Object.values(trees).map(tree => (
            <option key={tree.id} value={tree.id}>
              {tree.name}
            </option>
          ))}
        </select>
        {errors.parentTree && <span className="input-error-message">{errors.parentTree}</span>}
      </div>

      {formData.parentTree > 0 && availableSkills.length > 0 && (
        <div className="input-group">
          <label className="input-label">Skill Prerequisiti</label>
          <div className="checkbox-group">
            {availableSkills.map(s => (
              <label key={s.id} className="checkbox-label">
                <input
                  type="checkbox"
                  checked={formData.previousSkills.includes(s.id)}
                  onChange={() => togglePreviousSkill(s.id)}
                />
                {s.name}
              </label>
            ))}
          </div>
        </div>
      )}

      <div className="form-actions">
        <Button type="submit" variant="primary" disabled={isSubmitting}>
          {isSubmitting ? 'Salvataggio...' : skill ? 'Aggiorna' : 'Crea'}
        </Button>
        <Button type="button" variant="error" onClick={onCancel} disabled={isSubmitting}>
          Annulla
        </Button>
      </div>
    </form>
  );
};