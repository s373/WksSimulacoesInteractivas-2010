ArrayList invaders = new ArrayList();

void addInvader() {
  Invader i = new Invader();
  invaders.add(i);
}

Invader getInvader(int i) {
  return (Invader)invaders.get(i);
}

