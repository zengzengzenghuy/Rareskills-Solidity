const { StandardMerkleTree } =  require("@openzeppelin/merkle-tree");
const fs = require("fs");


// (1)
const tree = StandardMerkleTree.load(JSON.parse(fs.readFileSync("tree.json", "utf8")));

// (2)
for (const [i, v] of tree.entries()) {
  if (v[0] === '0x4444444444444444444444444444444444444444') {
    // (3)
    const proof = tree.getProof(i);
    console.log('Value:', v);
    console.log('Proof:', proof);
  }
}

// Proof = 
// [
//     '0x60648906e1a3f55dd188e992dc24db68c6b6d455fe925705f5e110ed7889ad90',
//     '0x1c9f49112980e3497923e5b9211f64095a1c5d8b2afeb9dda9c89fbdc108e3b4',
//     '0x9af1dc97c972c581e3038f4acfae9614e511b3398aef14062e7ffc06b3486508'
// ]