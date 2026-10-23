const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

async function uploadPhoto(name: string): Promise<string> {
    await sleep(100);
    if (name.endsWith('.heic')) throw new Error(`unsupported: ${name}`);
    return `uploaded ${name}`;
}

async function uploadWithRetry(name: string, attempts: number): Promise<string> {
    if (!Number.isInteger(attempts) || attempts < 1) {
        throw new RangeError('attempts must be a positive integer');
    }

    let delay = 400;
    for (let attempt = 1; attempt <= attempts; attempt++) {
        try {
            return await uploadPhoto(name);
        } catch (error) {
            if (attempt === attempts) throw error;
            await sleep(delay);
            delay *= 2;
        }
    }

    throw new Error('Upload retry loop ended unexpectedly');
}

async function settle(p: Promise<string>): Promise<string> {
    try {
        return await p;
    } catch (e) {
        return `failed: ${(e as Error).message}`;
    }
}

const names = ['a.jpg', 'b.heic', 'c.jpg'];
const results = await Promise.all(names.map((n) => settle(uploadWithRetry(n, 3))));
for (const r of results) console.log(r);

try {
    await uploadPhoto('d.heic');
} catch (e) {
    console.log(`caught ${(e as Error).message}`);
}