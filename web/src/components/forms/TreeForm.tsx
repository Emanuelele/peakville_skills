import { useState, useEffect } from 'react';
import { Input } from '../elements/Input';
import { Button } from '../elements/Button';
import { validateTreeData } from '../../utils/validation';
import type { Tree } from '../../types';

interface TreeFormProps {
  tree?: Tree;
  onSubmit: (data: Partial<Tree>) => Promise<boolean>;
  onCancel: () => void;
}

export const TreeForm = ({ tree, onSubmit, onCancel }: TreeFormProps) => {
  const [formData, setFormData] = useState({
    name: tree?.name || '',
    description: tree?.description || '',
    price: tree?.price || 1,
  });
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    if (tree) {
      setFormData({
        name: tree.name,
        description: tree.description,
        price: tree.price,
      });
    }
  }, [tree]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    const validation = validateTreeData(formData);
    
    if (!validation.valid) {
      const errorMap: Record<string, string> = {};
      validation.errors.forEach(error => {
        if (error.includes('nome')) errorMap.name = error;
        if (error.includes('prezzo')) errorMap.price = error;
      });
      setErrors(errorMap);
      return;
    }

    setIsSubmitting(true);
    setErrors({});

    const success = await onSubmit(formData);
    
    setIsSubmitting(false);
    
    if (success) {
      setFormData({ name: '', description: '', price: 1 });
    }
  };

  return (
    <form onSubmit={handleSubmit} className="form">
      <Input
        label="Nome Albero"
        value={formData.name}
        onChange={(e) => {
          setFormData({ ...formData, name: e.target.value });
        }}
        error={errors.name}
        required
        maxLength={100}
        placeholder="Es: Albero della Forza"
      />

      <div className="input-group">
        <label className="input-label">Descrizione</label>
        <textarea
          className="input textarea"
          value={formData.description}
          onChange={(e) => {
            setFormData({ ...formData, description: e.target.value });
          }}
          rows={4}
          placeholder="Descrizione dell'albero..."
        />
      </div>

      <Input
        label="Prezzo (Token)"
        type="number"
        value={formData.price}
        onChange={(e) => {
          const value = parseInt(e.target.value) || 1;
          setFormData({ ...formData, price: value });
        }}
        error={errors.price}
        required
        min={1}
        placeholder="Es: 5"
      />

      <div className="form-actions">
        <Button type="submit" variant="primary" disabled={isSubmitting}>
          {isSubmitting ? 'Salvataggio...' : tree ? 'Aggiorna' : 'Crea'}
        </Button>
        <Button type="button" variant="error" onClick={() => {
          onCancel();
        }} disabled={isSubmitting}>
          Annulla
        </Button>
      </div>
    </form>
  );
};