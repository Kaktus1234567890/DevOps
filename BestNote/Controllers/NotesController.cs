using BestNote.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using System.Text.Json.Serialization;


namespace BestNote.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotesController : ControllerBase
    {
        // localhost:44367/api/NotesController
        List<BNote> notes = new List<BNote>();
        //private readonly NotesContext _db;

        public NotesController(NotesContext db)
        {
            notes = JsonInteracter.Read();
            //_db = db;
        }

        [HttpPost]
        public IActionResult CreateNote(BNote note)
        {
            notes.Add(note);
            JsonInteracter.Write(notes);

            return CreatedAtAction("GetNote", new {id = note.id}, note);
        }

        [HttpGet]
        public IActionResult GetNote(long id)
        {
            BNote note;
            foreach(BNote n in notes)
            {
                if(n.id == id)
                {
                    note = n;
                    return Ok(note);
                }
            }

            return NotFound();
        }
    }

    public class JsonInteracter
    {
        public static List<BNote> Read()
        {
            string fileName = "Notizen.json";
            string jsonString = File.ReadAllText(fileName);
            JsonSerializerOptions options = new JsonSerializerOptions
            {
                IncludeFields = true
            };

            List<BNote>? notize = JsonSerializer.Deserialize<List<BNote>>(jsonString, options);
            return notize;
        }

        public static void Write(List<BNote> notes)
        {
            string fileName = "Notizen.json";
            JsonSerializerOptions options = new JsonSerializerOptions
            {
                WriteIndented = true
            };
            var json = JsonSerializer.Serialize(notes, options);
            File.WriteAllText(fileName, json);
        }
    }
}
