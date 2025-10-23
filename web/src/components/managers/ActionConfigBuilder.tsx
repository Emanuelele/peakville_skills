import { useState, useEffect } from 'react';
import { Input } from '../elements/Input';
import { Button } from '../elements/Button';

interface ActionParameter {
  key: string;
  value: string | string[];
  type: 'single' | 'multiple';
}

interface ActionConfigBuilderProps {
  value: Record<string, any>;
  onChange: (config: Record<string, any>) => void;
  availableActions: Record<string, {
    label: string;
    category: string;
    parameters?: Record<string, { type: string; required: boolean }>;
  }>;
}

export const ActionConfigBuilder = ({ value, onChange, availableActions }: ActionConfigBuilderProps) => {
  const [selectedAction, setSelectedAction] = useState<string>('');
  const [conditions, setConditions] = useState<ActionParameter[]>([]);
  const [maxPerAction, setMaxPerAction] = useState<number | null>(null);

  useEffect(() => {
    if (value.action) {
      setSelectedAction(value.action);
      
      if (value.conditions) {
        const conditionsArray: ActionParameter[] = [];
        Object.entries(value.conditions).forEach(([key, val]) => {
          conditionsArray.push({
            key,
            value: Array.isArray(val) ? val : String(val),
            type: Array.isArray(val) ? 'multiple' : 'single'
          });
        });
        setConditions(conditionsArray);
      }
      
      if (value.max_per_action) {
        setMaxPerAction(value.max_per_action);
      }
    }
  }, [value]);

  const updateConfig = (action: string, conds: ActionParameter[], max: number | null) => {
    const conditionsObj: Record<string, any> = {};
    
    conds.forEach(cond => {
      if (cond.key && cond.value) {
        conditionsObj[cond.key] = cond.value;
      }
    });

    const config: Record<string, any> = {
      action
    };

    if (Object.keys(conditionsObj).length > 0) {
      config.conditions = conditionsObj;
    }

    if (max !== null && max > 0) {
      config.max_per_action = max;
    }

    onChange(config);
  };

  const handleActionChange = (action: string) => {
    setSelectedAction(action);
    setConditions([]);
    updateConfig(action, [], maxPerAction);
  };

  const handleAddCondition = () => {
    const newConditions = [...conditions, { key: '', value: '', type: 'single' as const }];
    setConditions(newConditions);
    updateConfig(selectedAction, newConditions, maxPerAction);
  };

  const handleRemoveCondition = (index: number) => {
    const newConditions = conditions.filter((_, i) => i !== index);
    setConditions(newConditions);
    updateConfig(selectedAction, newConditions, maxPerAction);
  };

  const handleConditionChange = (index: number, field: 'key' | 'value' | 'type', val: any) => {
    const newConditions = [...conditions];
    
    if (field === 'type') {
      newConditions[index][field] = val;
      if (val === 'single' && Array.isArray(newConditions[index].value)) {
        newConditions[index].value = '';
      } else if (val === 'multiple' && !Array.isArray(newConditions[index].value)) {
        newConditions[index].value = [];
      }
    } else {
      newConditions[index][field] = val;
    }
    
    setConditions(newConditions);
    updateConfig(selectedAction, newConditions, maxPerAction);
  };

  const handleMultipleValueAdd = (index: number, val: string) => {
    if (!val.trim()) return;
    
    const newConditions = [...conditions];
    const currentValues = Array.isArray(newConditions[index].value) 
      ? newConditions[index].value 
      : [];
    newConditions[index].value = [...currentValues, val.trim()];
    
    setConditions(newConditions);
    updateConfig(selectedAction, newConditions, maxPerAction);
  };

  const handleMultipleValueRemove = (condIndex: number, valIndex: number) => {
    const newConditions = [...conditions];
    const currentValues = Array.isArray(newConditions[condIndex].value) 
      ? newConditions[condIndex].value 
      : [];
    newConditions[condIndex].value = currentValues.filter((_, i) => i !== valIndex);
    
    setConditions(newConditions);
    updateConfig(selectedAction, newConditions, maxPerAction);
  };

  const handleMaxPerActionChange = (val: number | null) => {
    setMaxPerAction(val);
    updateConfig(selectedAction, conditions, val);
  };

  const getActionParameters = () => {
    if (!selectedAction || !availableActions[selectedAction]) return [];
    return Object.entries(availableActions[selectedAction].parameters || {});
  };

  return (
    <div className="action-config-builder">
      <div className="input-group">
        <label className="input-label">Azione</label>
        <select
          className="input"
          value={selectedAction}
          onChange={(e) => handleActionChange(e.target.value)}
        >
          <option value="">Seleziona un'azione</option>
          {Object.entries(availableActions).map(([key, action]) => (
            <option key={key} value={key}>
              {action.label} ({action.category})
            </option>
          ))}
        </select>
      </div>

      {selectedAction && (
        <>
          <div className="action-info">
            <h4>Parametri disponibili:</h4>
            {getActionParameters().length > 0 ? (
              <ul>
                {getActionParameters().map(([paramKey, paramConfig]) => (
                  <li key={paramKey}>
                    <strong>{paramKey}</strong> ({paramConfig.type})
                    {paramConfig.required && <span className="badge-warning"> Obbligatorio</span>}
                  </li>
                ))}
              </ul>
            ) : (
              <p>Nessun parametro configurabile</p>
            )}
          </div>

          <div className="conditions-section">
            <div className="section-header">
              <label className="input-label">Condizioni</label>
              <Button type="button" variant="primary" size="sm" onClick={handleAddCondition}>
                + Aggiungi Condizione
              </Button>
            </div>

            {conditions.map((condition, index) => (
              <div key={index} className="condition-item">
                <Input
                  placeholder="Nome parametro"
                  value={condition.key}
                  onChange={(e) => handleConditionChange(index, 'key', e.target.value)}
                />

                <select
                  className="input"
                  value={condition.type}
                  onChange={(e) => handleConditionChange(index, 'type', e.target.value as 'single' | 'multiple')}
                >
                  <option value="single">Valore Singolo</option>
                  <option value="multiple">Valori Multipli</option>
                </select>

                {condition.type === 'single' ? (
                  <Input
                    placeholder="Valore"
                    value={condition.value as string}
                    onChange={(e) => handleConditionChange(index, 'value', e.target.value)}
                  />
                ) : (
                  <div className="multiple-values">
                    <div className="values-list">
                      {(condition.value as string[]).map((val, valIndex) => (
                        <div key={valIndex} className="value-chip">
                          <span>{val}</span>
                          <button
                            type="button"
                            onClick={() => handleMultipleValueRemove(index, valIndex)}
                          >
                            ×
                          </button>
                        </div>
                      ))}
                    </div>
                    <div className="add-value-input">
                      <input
                        className="input"
                        placeholder="Aggiungi valore"
                        onKeyPress={(e) => {
                          if (e.key === 'Enter') {
                            e.preventDefault();
                            handleMultipleValueAdd(index, (e.target as HTMLInputElement).value);
                            (e.target as HTMLInputElement).value = '';
                          }
                        }}
                      />
                    </div>
                  </div>
                )}

                <Button
                  type="button"
                  variant="error"
                  size="sm"
                  onClick={() => handleRemoveCondition(index)}
                >
                  Rimuovi
                </Button>
              </div>
            ))}
          </div>

          <div className="input-group">
            <label className="checkbox-label">
              <input
                type="checkbox"
                checked={maxPerAction !== null}
                onChange={(e) => handleMaxPerActionChange(e.target.checked ? 1 : null)}
              />
              Limita steps per azione
            </label>
            
            {maxPerAction !== null && (
              <Input
                type="number"
                label="Max steps per azione"
                value={maxPerAction}
                onChange={(e) => handleMaxPerActionChange(parseInt(e.target.value) || 1)}
                min={1}
              />
            )}
          </div>
        </>
      )}
    </div>
  );
};