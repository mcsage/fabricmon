/*
 * FabricMon - an InfiniBand fabric monitor daemon.
 * Copyright 2017 Daniel Swarbrick
 */

// nodeImageMap is an array of regex-URL pairs. The node description will be tested against each
// regex in the specified order, and the first match will determine the image used for the node.
// The last regex should be a catch-all pattern.
var nodeImageMap = [
  [/^gw(\d+[ab]-\d+|\d+)/, "img/router.svg"],
  [/^(ps\d+[ab]-\d+|pserver\d+)/, "img/cpu.svg"],
  [/^(st\d+[ab]-\d+|storage\d+)/, "img/hdd.svg"],
  [/./, "img/default.svg"]
];
