export const validateTreeData = (data: {
  name?: string;
  description?: string;
  price?: number;
}): { valid: boolean; errors: string[] } => {
  const errors: string[] = [];

  if (data.name !== undefined) {
    if (!data.name || data.name.trim().length === 0) {
      errors.push('Il nome è obbligatorio');
    }
    if (data.name.length > 100) {
      errors.push('Il nome non può superare i 100 caratteri');
    }
  }

  if (data.price !== undefined) {
    if (data.price < 1) {
      errors.push('Il prezzo deve essere almeno 1');
    }
    if (!Number.isInteger(data.price)) {
      errors.push('Il prezzo deve essere un numero intero');
    }
  }

  return { valid: errors.length === 0, errors };
};

export const validateSkillData = (data: {
  name?: string;
  description?: string;
  price?: number;
  parentTree?: string;
}): { valid: boolean; errors: string[] } => {
  const errors: string[] = [];

  if (data.name !== undefined) {
    if (!data.name || data.name.trim().length === 0) {
      errors.push('Il nome è obbligatorio');
    }
    if (data.name.length > 100) {
      errors.push('Il nome non può superare i 100 caratteri');
    }
  }

  if (data.price !== undefined) {
    if (data.price < 1) {
      errors.push('Il prezzo deve essere almeno 1');
    }
    if (!Number.isInteger(data.price)) {
      errors.push('Il prezzo deve essere un numero intero');
    }
  }

  if (data.parentTree !== undefined) {
    if (!Number.isInteger(data.parentTree)) {
      errors.push('L\'albero genitore deve essere valido');
    }
  }

  return { valid: errors.length === 0, errors };
};

export const validateQuestData = (data: {
  name?: string;
  description?: string;
  XP?: number;
  steps?: number;
}): { valid: boolean; errors: string[] } => {
  const errors: string[] = [];

  if (data.name !== undefined) {
    if (!data.name || data.name.trim().length === 0) {
      errors.push('Il nome è obbligatorio');
    }
    if (data.name.length > 100) {
      errors.push('Il nome non può superare i 100 caratteri');
    }
  }

  if (data.XP !== undefined) {
    if (data.XP < 1) {
      errors.push('L\'XP deve essere almeno 1');
    }
    if (!Number.isInteger(data.XP)) {
      errors.push('L\'XP deve essere un numero intero');
    }
  }

  if (data.steps !== undefined) {
    if (data.steps < 1) {
      errors.push('Gli steps devono essere almeno 1');
    }
    if (!Number.isInteger(data.steps)) {
      errors.push('Gli steps devono essere un numero intero');
    }
  }

  return { valid: errors.length === 0, errors };
};