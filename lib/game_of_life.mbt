enum Cell {
  Dead
  Alive
}

struct Universe {
  width : Int
  height : Int
  mut cells : Array[Cell]
}

func get_index(self : Universe, row : Int, column : Int) -> Int {
  row * self.width + column
}

pub func new() -> Universe {
  let width = 64
  let height = 64
  let cells : Array[Cell] = array_make(width * height, Dead)
  var idx = 0
  while idx < width * height {
    if idx % 2 == 0 || idx % 7 == 0 {
      cells[idx] = Alive
    } else {
      cells[idx] = Dead
    }
    idx = idx + 1
  }
  { width, height, cells }
}

pub func get_width(self : Universe) -> Int {
  self.width
}

pub func get_height(self : Universe) -> Int {
  self.height
}

pub func get_cells(self : Universe) -> Array[Cell] {
  self.cells
}

pub func get_cell(self : Universe, idx : Int) -> Int {
  match self.cells[idx] {
    Alive => 1
    Dead => 0
  }
}

func live_neighbor_count(self : Universe, row : Int, column : Int) -> Int {
  var count = 0
  let delta_rows = [self.height - 1, 0, 1]
  let delta_cols = [self.width - 1, 0, 1]
  var r = 0
  while r < 3 {
    var c = 0
    while c < 3 {
      if delta_rows[r] == 0 && delta_cols[c] == 0 {
        c = c + 1
        continue
      }
      let neighbor_row = (row + delta_rows[r]) % self.height
      let neighbor_col = (column + delta_cols[c]) % self.width
      let idx = self.get_index(neighbor_row, neighbor_col)
      count = count + self.get_cell(idx)
      c = c + 1
    }
    r = r + 1
  }
  count
}

pub func tick(self : Universe) {
  var next : Array[Cell] = array_make(self.width * self.height, Dead)
  var r = 0
  while r < self.height {
    var c = 0
    while c < self.width {
      let idx = self.get_index(r, c)
      let cell = self.cells[idx]
      let live_neighbor = self.live_neighbor_count(r, c)
      let next_cell : Cell = match (cell, live_neighbor) {
        (Alive, c) =>
          if c < 2 {
            Dead
          } else if c == 2 || c == 3 {
            Alive
          } else {
            Dead
          }
        (Dead, 3) => Alive
        _ => cell
      }
      next[idx] = next_cell
      c = c + 1
    }
    r = r + 1
  }
  self.cells = next
}

pub func to_string(self : Universe) -> String {
  var r = 0
  var cells = ""
  while r < self.height {
    var c = 0
    while c < self.width {
      let idx = self.get_index(r, c)
      let cell = self.cells[idx]
      // No buffer implementation?
      cells = cells +
      match cell {
        Alive => "▅"
        Dead => "☐"
      }
      c = c + 1
    }
    cells = cells + "\n"
    r = r + 1
  }
  cells
}

pub func print(self : Universe) {
  var r = 0
  while r < self.height {
    var c = 0
    while c < self.width {
      let idx = self.get_index(r, c)
      let cell = self.cells[idx]
      match cell {
        Alive => "▅".print()
        Dead => "☐".print()
      }
      c = c + 1
    }
    "\n".print()
    r = r + 1
  }
}

