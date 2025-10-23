import { useState, useCallback } from 'react';
import type { InitData } from '../types';
import { fetchNui } from '../utils/fetchNui';

export const useSkillsData = () => {
  const [data, setData] = useState<InitData | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const updateData = useCallback((newData: InitData) => {
    setData(newData);
    setError(null);
  }, []);

  const refreshData = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      await new Promise(resolve => setTimeout(resolve, 100));
      setLoading(false);
    } catch (err) {
      setError('Errore durante il caricamento dei dati');
      setLoading(false);
    }
  }, []);

  const purchaseTree = useCallback(async (treeId: string): Promise<boolean> => {
    setLoading(true);
    setError(null);
    try {
      const success = await fetchNui<boolean>('purchaseTree', treeId);
      setLoading(false);
      return success;
    } catch (err) {
      setError('Errore durante l\'acquisto dell\'albero');
      setLoading(false);
      return false;
    }
  }, []);

  const refundTree = useCallback(async (treeId: string): Promise<boolean> => {
    setLoading(true);
    setError(null);
    try {
      const success = await fetchNui<boolean>('refundTree', treeId);
      setLoading(false);
      return success;
    } catch (err) {
      setError('Errore durante il rimborso dell\'albero');
      setLoading(false);
      return false;
    }
  }, []);

  const purchaseSkill = useCallback(async (skillId: string): Promise<boolean> => {
    setLoading(true);
    setError(null);
    try {
      const success = await fetchNui<boolean>('purchaseSkill', skillId);
      setLoading(false);
      return success;
    } catch (err) {
      setError('Errore durante l\'acquisto della skill');
      setLoading(false);
      return false;
    }
  }, []);

  const refundSkill = useCallback(async (skillId: string): Promise<boolean> => {
    setLoading(true);
    setError(null);
    try {
      const success = await fetchNui<boolean>('refundSkill', skillId);
      setLoading(false);
      return success;
    } catch (err) {
      setError('Errore durante il rimborso della skill');
      setLoading(false);
      return false;
    }
  }, []);

  const selectQuest = useCallback(async (questId: string): Promise<boolean> => {
    setLoading(true);
    setError(null);
    try {
      const success = await fetchNui<boolean>('selectQuest', questId);
      setLoading(false);
      return success;
    } catch (err) {
      setError('Errore durante la selezione della quest');
      setLoading(false);
      return false;
    }
  }, []);

  const deselectQuest = useCallback(async (questId: string): Promise<boolean> => {
    setLoading(true);
    setError(null);
    try {
      const success = await fetchNui<boolean>('deselectQuest', questId);
      setLoading(false);
      return success;
    } catch (err) {
      setError('Errore durante la deselezione della quest');
      setLoading(false);
      return false;
    }
  }, []);

  return {
    data,
    loading,
    error,
    updateData,
    refreshData,
    purchaseTree,
    refundTree,
    purchaseSkill,
    refundSkill,
    selectQuest,
    deselectQuest,
  };
};