import { useEffect } from 'react';

interface NuiMessageData<T = unknown> {
    action: string;
    data?: T;
}

export const useNuiEvent = <T = unknown>(
    action: string,
    handler: (data: T) => void
) => {
    useEffect(() => {
        const eventListener = (event: MessageEvent<NuiMessageData<T>>) => {
            if (event.data.action === action) {
                handler(event.data.data as T);
            }
        };

        window.addEventListener('message', eventListener);
        return () => window.removeEventListener('message', eventListener);
    }, [action, handler]);
};
