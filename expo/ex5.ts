type SyncEvent =
    | { kind: 'queued'; photo: string }
    | { kind: 'uploaded'; photo: string; ms: number }
    | { kind: 'failed'; photo: string; retryIn: number }
    | { kind: 'cancelled'; photo: string; reason: string };

async function* events(): AsyncGenerator<SyncEvent> {
    yield { kind: 'queued', photo: 'a.jpg' };
    yield { kind: 'uploaded', photo: 'a.jpg', ms: 840 };
    yield { kind: 'failed', photo: 'b.jpg', retryIn: 30 };
    yield { kind: 'cancelled', photo: 'c.jpg', reason: 'user requested' };
}

function describe(e: SyncEvent): string {
    switch (e.kind) {
        case 'queued':
            return `${e.photo} waits for Wi-Fi`;
        case 'uploaded':
            return `${e.photo} up in ${e.ms} ms`;
        case 'failed':
            return `${e.photo} retries in ${e.retryIn} s`;
        case 'cancelled':
            return `${e.photo} cancelled: ${e.reason}`;
    }
}

for await (const e of events()) console.log(describe(e));

const [count, label] = [3, 'photos'] as const; // a tuple, destructured
console.log(`${count} ${label} queued`);