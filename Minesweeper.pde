import de.bezier.guido.*;
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private static boolean lost = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
//mines initialized here
void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  int numMines = (int) (Math.random()*50);
  for (int i = 0; i < numMines; i++) {
    setMines();
  }
}
public void setMines()
{
  int r = (int) (Math.random()*NUM_ROWS);
  int c = (int) (Math.random()*NUM_COLS);
  if (!mines.contains(buttons[r][c])) {
    mines.add(buttons[r][c]);
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon() {
  for (int i = 0; i < buttons.length; i++) {
    for (int j = 0; j < buttons[i].length; j++) {
      if (mines.contains(buttons[i][j]) && !buttons[i][j].isFlagged()) {
        return false;
      }
      if (!mines.contains(buttons[i][j]) && !buttons[i][j].clicked) {
        return false;
      }
    }
  }

  return true;
}
public void displayLosingMessage()
{
  String loseMsg = "You Lost!";
  for (int i = 0; i < loseMsg.length(); i++) {
    MSButton msg = new MSButton(0, i);
    msg.setLabel(loseMsg.substring(i, i+1));
  }
  for (int i = 0; i < mines.size(); i++){
    mines.get(i).setClicked(true);
    mines.get(i).draw();
  }
}
public void displayWinningMessage()
{
  String winMsg = "You Win!";
  for (int i = 0; i < winMsg.length(); i++) {
    MSButton msg = new MSButton(0, i);
    msg.setLabel(winMsg.substring(i, i+1));
  }
}
public boolean isValid(int r, int c)
{
  if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
    return true;
  return false;
}
public int countMines(int row, int col)
{
  int neighbors = 0;
  for (int x = -1; x < 2; x++) {
    for (int i = -1; i < 2; i++) {
      if (isValid(row-i, col-x))
        if (mines.contains(buttons[row-i][col-x]))
          neighbors++;
    }
  }
  if (mines.contains(buttons[row][col])) neighbors -= 1;
  return neighbors;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    if (!lost){
    if (mouseButton == RIGHT && !this.clicked) {
      if (this.flagged) {
        this.flagged = false; 
        clicked = false;
      } 
      else this.flagged = true;
    } 
    else if (mines.contains(this)) {
      displayLosingMessage();
      clicked = true;
      lost = true;
    } 
    else if (countMines(this.myRow, this.myCol) > 0) {
      setLabel(""+countMines(this.myRow, this.myCol));
      clicked = true;
    }
    else{
      clicked = true;
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          if (i == 0 && j == 0) {
            continue;
          }

          if (isValid(myRow + i, myCol + j)) {
            if (!buttons[myRow + i][myCol + j].flagged && !buttons[myRow + i][myCol + j].clicked) {
              buttons[myRow + i][myCol + j].mousePressed();
            }
          }
        }
      }
    }
  }
  }
public void draw () 
{    
  if (flagged)
    fill(0);
  else if ( clicked && mines.contains(this) ) 
    fill(255, 0, 0);
  else if (clicked)
    fill( 200 );
  else 
  fill( 100 );

  rect(x, y, width, height);
  fill(0);
  text(myLabel, x+width/2, y+height/2);
}
public void setLabel(String newLabel)
{
  myLabel = newLabel;
}
public void setLabel(int newLabel)
{
  myLabel = ""+ newLabel;
}
public boolean isFlagged()
{
  return flagged;
}
public void setClicked(boolean clicked){
  this.clicked = clicked;
}
}
