import { useEffect, useCallback } from 'react';
import type { NuiMessageData } from '../types';

export const useNuiEvent = <T = unknown>(
    action: string,
    handler: (data: T) => void
) => {
    const memoizedHandler = useCallback(handler, []);
    
    useEffect(() => {
        const eventListener = (event: MessageEvent<NuiMessageData<T>>) => {
            if (event.data.action === action) {
                memoizedHandler(event.data.data as T);
            }
        };

        window.addEventListener('message', eventListener);
        return () => window.removeEventListener('message', eventListener);
    }, [action, memoizedHandler]);
};
