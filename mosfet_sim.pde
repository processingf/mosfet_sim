/* @pjs preload="data/id_vds-nmos.png"; */
/* @pjs preload="data/id_vgs-nmos.png"; */
/* @pjs preload="data/id_vds-pmos.png"; */
/* @pjs preload="data/id_vgs-pmos.png"; */
/* @pjs font="data/BellMTItalic-14.ttf"; */

int Sel;
PImage back[];
PFont segoe, brush, bell, bradley;
float Vg, Vd, Vt, Vov, Id, kd, lb;

void setup()
{
  size(1000, 520);
  smooth();
  background(210,220,120);
  back = new PImage[4];
  back[0] = loadImage("data/id_vds-nmos.png");
  back[1] = loadImage("data/id_vgs-nmos.png");
  back[2] = loadImage("data/id_vds-pmos.png");
  back[3] = loadImage("data/id_vgs-pmos.png");
  bell = loadFont("data/BellMTItalic-14.vlw");
  // Default Values
  Sel = 0;
  Vg = 0.0;
  Vd = 0.0;
  Vt = 2.0;
  kd = 0.001; // kn'(W/L)
  lb = 0.0001; // lambda vDS
}


void draw()
{
  float vds, vgs, Vgg, Vdd, Vtt;
  int mX, mY, x, y, x0, y0;
  boolean mP;

  image(back[Sel], 0, 0);  
  // Realtime
  mX = mouseX;
  mY = mouseY;
  mP = mousePressed;
  if((mX < 400) && mP) // Near any scroll or button?
  {
    if(((mX < 105) && (mX > 15)) && ((mY < 350) && (mY > 130))) // Vg Scroll
    {
      Vg = (340.0 - mY) / 20.0;
      if(Vg < 0.0) Vg = 0.0;
      else if(Vg > 10.0) Vg = 10.0;
    }
    else if(((mX < 415) && (mX > 285)) && ((mY < 350) && (mY > 130))) // Vt Scroll
    {
      Vt = (340.0 - mY) / 20.0;
      if(Vt < 0.0) Vt = 0;
      else if(Vt > 10.0) Vt = 10.0;
    }
    else if(((mX < 325) && (mX > 115)) && ((mY < 125) && (mY > 45))) // Vd Scroll
    {
      Vd = (mX - 120.0) / 10.0;
      if(Vd < 0.0) Vd = 0.0;
      else if(Vd > 20.0) Vd = 20.0;
    }
    else if(((mX>=180) && (mX<=280)) && ((mY>=420) && (mY<=460))) Sel = Sel & 2;
    else if(((mX>=290) && (mX<=390)) && ((mY>=420) && (mY<=460))) Sel = Sel | 1;
    else if(((mX>=180) && (mX<=280)) && ((mY>=470) && (mY<=510))) Sel = Sel & 1;
    else if(((mX>=290) && (mX<=390)) && ((mY>=470) && (mY<=510))) Sel = Sel | 2;    
  }
  // Draw scrolls
  strokeWeight(10);
  stroke(120, 70, 150);
  y = 340 - (int)(Vg*20.0); // Vg scroll
  line(48, y, 52, y);
  stroke(140, 90, 170);
  line(49, y, 51, y);
  y = 340 - (int)(Vt*20.0); // Vt scroll
  line(348, y, 352, y);
  stroke(140, 90, 170);
  line(349, y, 351, y);
  x = 120 + (int)(Vd*10.0); // Vd scroll
  line(x, 98, x, 102);
  stroke(140, 90, 170);
  line(x, 99, x, 101);

  if(Sel <= 1)
  {
    Vgg = Vg;
    Vdd = Vd;
    Vtt = Vt;
  }
  else
  {
    Vgg = Vg - 10.0;
    Vdd = -Vd;
    Vtt = Vt - 10.0;
  }
  switch(Sel)
  {
    case 0:
    // Draw Vg ghost graph
    strokeWeight(5);
    stroke(190, 200, 100);
    Vov = Vg - Vt;
    if(Vov < 0.0) Vov = 0.0;
    x0 = 0;
    y0 = 0;
    for(x=0; x<500; x++)
    {
      vds = x / 25.0;
      if(Vov > vds) y = (int)(6000*kd*(Vov - 0.5*vds)*vds); // triode region
      else y = (int)(6000*0.5*kd*Vov*Vov*(1 + lb*vds)); // saturation region
      line(455+x0, 395-y0, 455+x, 395-y);
      x0 = x;
      y0 = y;
    }
    // Draw Vd Pointer
    stroke(90, 90,210);
    x = (int)(Vd*25.0);
    if(Vov > Vd) Id = 1000.0*kd*(Vov - 0.5*Vd)*Vd; // triode region
    else Id = 1000.0*0.5*kd*Vov*Vov*(1 + lb*Vd); // saturation region
    y = (int)(6.0*Id);
    line(455+x, 395, 455+x, 395-y);
    strokeWeight(1);
    stroke(100, 100, 100);
    line(455+x, 395-y, 453, 395-y);
    break;

    case 1:
    // Draw Vg ghost graph
    strokeWeight(5);
    stroke(190, 200, 100);
    x0 = 0;
    y0 = 0;
    for(x=0; x<500; x++)
    {
      vgs = (x / 50.0) - Vt;
      if(vgs < 0.0) vgs = 0.0;
      if(vgs > Vd) y = (int)(6000*kd*(vgs - 0.5*Vd)*Vd); // triode region
      else y = (int)(6000*0.5*kd*vgs*vgs*(1 + lb*Vd)); // saturation region
      line(455+x0, 395-y0, 455+x, 395-y);
      x0 = x;
      y0 = y;
    }
    // Draw Vg Pointer
    stroke(90, 90,210);
    x = (int)(Vg*50.0);
    vgs = Vg - Vt;
    if(vgs < 0.0) vgs = 0.0;
    if(vgs > Vd) Id = 1000.0*kd*(vgs - 0.5*Vd)*Vd; // triode region
    else Id = 1000.0*0.5*kd*vgs*vgs*(1 + lb*Vd); // saturation region
    y = (int)(6.0*Id);
    line(455+x, 395, 455+x, 395-y);
    strokeWeight(1);
    stroke(100, 100, 100);
    line(455+x, 395-y, 453, 395-y);
    break;
    
    case 2:
    // Draw Vg ghost graph
    strokeWeight(5);
    stroke(190, 200, 100);
    Vov = -(Vgg - Vtt);
    if(Vov < 0.0) Vov = 0.0;
    x0 = 0;
    y0 = 0;
    for(x=0; x<500; x++)
    {
      vds = x / 25.0;
      if(Vov > vds) y = (int)(6000*kd*(Vov - 0.5*vds)*vds); // triode region
      else y = (int)(6000*0.5*kd*Vov*Vov*(1 + lb*vds)); // saturation region
      line(925-x0, 125+y0, 925-x, 125+y);
      x0 = x;
      y0 = y;
    }
    // Draw Vd Pointer
    stroke(90, 90,210);
    x = (int)(Vd*25.0);
    if(Vov > Vd) Id = 1000.0*kd*(Vov - 0.5*Vd)*Vd; // triode region
    else Id = 1000.0*0.5*kd*Vov*Vov*(1 + lb*Vd); // saturation region
    y = (int)(6.0*Id);
    line(925-x, 125, 925-x, 125+y);
    strokeWeight(1);
    stroke(100, 100, 100);
    line(925-x, 125+y, 928, 125+y);
    break;
    
    default:
    // Draw Vg ghost graph
    strokeWeight(5);
    stroke(190, 200, 100);
    x0 = 0;
    y0 = 0;
    for(x=0; x<500; x++)
    {
      vgs = (x / 50.0) + Vtt;
      if(vgs < 0.0) vgs = 0.0;
      if(vgs > Vd) y = (int)(6000*kd*(vgs - 0.5*Vd)*Vd); // triode region
      else y = (int)(6000*0.5*kd*vgs*vgs*(1 + lb*Vd)); // saturation region
      line(925-x0, 125+y0, 925-x, 125+y);
      x0 = x;
      y0 = y;
    }
    // Draw Vg Pointer
    stroke(90, 90,210);
    x = (int)(-Vgg*50.0);
    vgs = -Vgg + Vtt;
    if(vgs < 0.0) vgs = 0.0;
    if(vgs > Vd) Id = 1000.0*kd*(vgs - 0.5*Vd)*Vd; // triode region
    else Id = 1000.0*0.5*kd*vgs*vgs*(1 + lb*Vd); // saturation region
    y = (int)(6.0*Id);
    line(925-x, 125, 925-x, 125+y);
    strokeWeight(1);
    stroke(100, 100, 100);
    line(925-x, 125+y, 928, 125+y);
    break;
  }
  // Draw Current arrow
  if(Id > 0.0)
  {
    strokeWeight(Id+0.5);
    stroke(180, 180, 250);
    line(280, 180, 280, 300);
    line(280, 300, 260, 280);
    line(280, 300, 300, 280);
  }
  if((Sel & 2) > 0) Id = -Id;
  // Draw Values (info)
  textFont(bell, 14);
  fill(80, 80, 80);
  if((Sel & 2) > 0) text("kp  = "+kd+" mA/V", 10, 455);
  else text("kn  = "+kd+" mA/V", 10, 455);
  text("Vgs = "+Vgg+" V", 10, 470);
  text("Vds = "+Vdd+" V", 10, 485);
  text("Vt  = "+Vtt+" V", 10, 500);
  text("Id  = "+Id+" mA", 10, 515);
}
