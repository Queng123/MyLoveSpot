const express = require('express');
const index = require('./routes/index.routes');

const app = express();
const port = 3000;

app.use(express.json());
app.use(index);

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
