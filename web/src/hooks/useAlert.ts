import { useState, useCallback } from 'react';

interface AlertConfig {
  title: string;
  message: string;
  type?: 'info' | 'success' | 'error' | 'warning';
}

export const useAlert = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [config, setConfig] = useState<AlertConfig>({
    title: '',
    message: '',
    type: 'info'
  });

  const showAlert = useCallback((alertConfig: AlertConfig) => {
    setConfig(alertConfig);
    setIsOpen(true);
  }, []);

  const closeAlert = useCallback(() => {
    setIsOpen(false);
  }, []);

  return {
    isOpen,
    config,
    showAlert,
    closeAlert
  };
};