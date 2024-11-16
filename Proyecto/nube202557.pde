punto nube[];
linea cierre[];
int numPuntos;
int lineasEnCierre;

void setup() {
  background(0);
  size(1300, 800);
  
  numPuntos = 100;
  lineasEnCierre = 0;
  nube = new punto[numPuntos];
  cierre = new linea[numPuntos + 1];
  
  // Generar puntos aleatorios
  for (int i = 0; i < numPuntos; i++) {
    nube[i] = new punto(random(1200) + 50, random(700) + 50);
  }
  
  // Calcular envolvente convexa
  ArrayList<punto> envolvente = calcularEnvolvente(nube);
  
  // Conectar puntos de la envolvente convexa
  for (int i = 0; i < envolvente.size(); i++) {
    punto a = envolvente.get(i);
    punto b = envolvente.get((i + 1) % envolvente.size());
    cierre[lineasEnCierre] = new linea(a, b);
    lineasEnCierre++;
  }
  
  // Conectar puntos internos de manera aleatoria
  while (lineasEnCierre < numPuntos - 2) {
    int indiceA = (int) random(numPuntos);
    int indiceB = (int) random(numPuntos);
    
    if (indiceA != indiceB) {
      punto a = nube[indiceA];
      punto b = nube[indiceB];
      
      boolean yaExiste = false;
      
      for (int j = 0; j < lineasEnCierre; j++) {
        if ((cierre[j].A == a && cierre[j].B == b) || 
            (cierre[j].A == b && cierre[j].B == a)) {
          yaExiste = true;
          break;
        }
      }
      
      if (!yaExiste) {
        cierre[lineasEnCierre] = new linea(a, b);
        lineasEnCierre++;
      }
    }
  }
}

void draw() {
  for (int i = 0; i < numPuntos; i++) {
    nube[i].dibuja();
  }
  for (int i = 0; i < lineasEnCierre; i++) {
    cierre[i].dibuja();
  }
}

// MÉTODO PARA CALCULAR LA ENVOLVENTE CONVEXA
ArrayList<punto> calcularEnvolvente(punto[] puntos) {
  ArrayList<punto> envolvente = new ArrayList<>();
  
  // Ordenar puntos manualmente por coordenada x, luego por y
  for (int i = 0; i < puntos.length - 1; i++) {
    for (int j = i + 1; j < puntos.length; j++) {
      if (puntos[i].x > puntos[j].x || 
          (puntos[i].x == puntos[j].x && puntos[i].y > puntos[j].y)) {
        // Intercambiar puntos
        punto temp = puntos[i];
        puntos[i] = puntos[j];
        puntos[j] = temp;
      }
    }
  }
  
  // Construir la mitad inferior de la envolvente
  for (int i = 0; i < puntos.length; i++) {
    while (envolvente.size() >= 2 && !esGiroALaIzquierda(
        envolvente.get(envolvente.size() - 2),
        envolvente.get(envolvente.size() - 1),
        puntos[i])) {
      envolvente.remove(envolvente.size() - 1);
    }
    envolvente.add(puntos[i]);
  }
  
  // Construir la mitad superior de la envolvente
  int tamInicial = envolvente.size();
  for (int i = puntos.length - 2; i >= 0; i--) {
    while (envolvente.size() > tamInicial && !esGiroALaIzquierda(
        envolvente.get(envolvente.size() - 2),
        envolvente.get(envolvente.size() - 1),
        puntos[i])) {
      envolvente.remove(envolvente.size() - 1);
    }
    envolvente.add(puntos[i]);
  }
  
  // Eliminar el último punto (es igual al primero)
  envolvente.remove(envolvente.size() - 1);
  
  return envolvente;
}

// MÉTODO PARA VERIFICAR GIRO A LA IZQUIERDA
boolean esGiroALaIzquierda(punto a, punto b, punto c) {
  return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x) > 0;
}
