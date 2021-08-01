require 'bundler/setup'

require 'stamp'

##
# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.
class Todo
  ##
  # Marker indicating the task is done.
  DONE_MARKER = 'X'

  ##
  # Whitespace indicating the task is not done.
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done, :due_date

  ##
  # Creates a new todo described by a +title+ and an optional +description+.
  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  ##
  # Mark the todo as done.
  def done!
    self.done = true
  end

  ##
  # Returns a boolean describing whether or not the todo is done.
  def done?
    done
  end

  ##
  # Mark the todo as undone.
  def undone!
    self.done = false
  end

  ##
  # Returns a formatted string with the current status of the todo, its title
  # and it's due date if any.
  def to_s
    result = "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
    result += due_date.stamp(' (Due: Friday January 6)') if due_date
    result
  end

  ##
  # Compare the todo's title, description and status with another todo's.
  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end

##
# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.
class TodoList
  attr_accessor :title

  ##
  # Creates a new collection of Todo objects described by a +title+ and a
  # collection of todo objects saved in +todos+.
  def initialize(title)
    @title = title
    @todos = []
  end

  ##
  # Returns the number of todo objects in this collection.
  def size
    @todos.size
  end

  ##
  # Returns the first todo object in the collection.
  def first
    @todos.first
  end

  ##
  # Returns the last todo object in the collection.
  def last
    @todos.last
  end

  ##
  # Removes and returns leading element.
  def shift
    @todos.shift
  end

  ##
  # Removes and returns trailing element.
  def pop
    @todos.pop
  end

  ##
  # Returns true if all todo objects in the collection are done; otherwise
  # false.
  def done?
    @todos.all? { |todo| todo.done? }
  end

  ##
  # Add a new todo object to the collection.
  #
  # A TypeError is raised if the added object is not an instance of the Todo
  # class.
  def <<(todo)
    raise TypeError, 'can only add Todo objects' unless todo.instance_of? Todo

    @todos << todo
  end
  alias_method :add, :<<

  ##
  # Returns the element at offset index.
  def item_at(idx)
    @todos.fetch(idx)
  end

  ##
  # Mark the element at offset index as done.
  def mark_done_at(idx)
    item_at(idx).done!
  end

  ##
  # Mark the element at offset index as undone.
  def mark_undone_at(idx)
    item_at(idx).undone!
  end

  ##
  # Mark all the elements in the collection as done.
  def done!
    @todos.each_index do |idx|
      mark_done_at(idx)
    end
  end

  ##
  # Deletes and returns the element at offset index.
  def remove_at(idx)
    @todos.delete(item_at(idx))
  end

  ##
  # Returns a formatted string of a list of all the todo elements as formatted
  # strings separated by a newline.
  def to_s
    text = "---- #{title} ----\n"
    text << @todos.map(&:to_s).join("\n")
    text
  end

  ##
  # Returns the collection of todos as an array
  def to_a
    @todos
  end

  ##
  # Iterates over the todo list elements and passes each successive element to
  # the bock; returns self.
  def each
    @todos.each do |todo|
      yield(todo)
    end
    self
  end

  ##
  # Calls the block with each element of self; returns a new TodoList containing
  # those elements of self for which the block returns a truthy value.
  def select
    list = TodoList.new(title)
    each do |todo|
      list.add(todo) if yield(todo)
    end
    list
  end

  ##
  # Returns first Todo by title, or nil if no match.
  def find_by_title(title)
    select { |todo| todo.title == title }.first
  end

  ##
  # Returns a list of todo which are done.
  def all_done
    select { |todo| todo.done? }
  end

  ##
  # Returns a list of todo which are not done.
  def all_not_done
    select { |todo| !todo.done? }
  end

  ##
  # Marks todo as done after retrieving it by title, or nil if no match.
  def mark_done(title)
    find_by_title(title) && find_by_title(title).done!
  end

  ##
  # Marks all todos as done.
  def mark_all_done
    each { |todo| todo.done! }
  end

  ##
  # Marks all todos as undone.
  def mark_all_undone
    each { |todo| todo.undone! }
  end
end
