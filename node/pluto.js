const spawn = require('child_process').spawn;
const net = require('net');


function startPluto() {
    return new Promise((resolve, reject) => {
        const srv = net.createServer(function(sock) {
            sock.end('Hello world\n');
        });
        srv.listen(0, function() {
            const freePort = srv.address().port;
            srv.close();

            const child = spawn('julia', ['-e', `import Pluto; Pluto.run(;launch_browser=false, port=${freePort})`]);
            
            const urlRegex = /http:\/\/\w+(\.\w+)*(:[0-9]+)?\/?(\/[.\w]*)*\??([-a-zA-Z0-9()@:%_\+.~#?&\/=]*)/g;
            child.stdout.on('data', function(chunk) {
                const urls = chunk.toString().match(urlRegex);
                if(urls && urls.length > 0) {
                    const url = new URL(urls[0]);
                    resolve({child, url});
                }
            });
            child.stderr.on('data', function(chunk) {
                const err = chunk.toString();
                // Check for a couple of important errors
                if(err.includes('Package Pluto not found in current path')) {
                    throw new Error(err);
                }
            });
        });
    });
}

function stopPluto(pluto) {
    pluto.child.kill('SIGINT');
}

module.exports = {startPluto, stopPluto};
