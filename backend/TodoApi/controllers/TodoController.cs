using Microsoft.AspNetCore.Mvc;
using TodoApi.Models;

namespace TodoApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TodoController : ControllerBase
    {
        private static List<TodoItem> todos = new();
        private static int nextId = 1;

        [HttpGet]
        public IEnumerable<TodoItem> GetTodos()
        {
            return todos;
        }

        [HttpPost]
        public IActionResult AddTodo(TodoItem todo)
        {
            todo.Id = nextId++;
            todos.Add(todo);
            return Ok(todo);
        }
    }
}
