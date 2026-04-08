using BestNote.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Net.Http.Headers;
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
        public IActionResult CreateNote(BNote2 note)
        {
            Response.Headers.Append("Access-Control-Allow-Origin", "*");

            BNote newNote = new(notes.Count, note.titel, note.inhalt);
            notes.Add(newNote);
            JsonInteracter.Write(notes);

            return CreatedAtAction("GetNote", new {id = newNote.id}, newNote);
        }

        [HttpGet("one")]
        public IActionResult GetNote(long id)
        {
            Response.Headers.Append("Access-Control-Allow-Origin", "*");

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

        [HttpGet("all")]
        public IActionResult GetAllNote()
        {
            Response.Headers.Append("Access-Control-Allow-Origin", "*");
            return Ok(notes);
        }

        [HttpDelete("all")]
        public IActionResult DeleteOne (int id)
        {
            Response.Headers.Append("Access-Control-Allow-Origin", "*");
            Response.Headers.Append("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");

            foreach (BNote n in notes)
            {
                if(n.id == id)
                {
                    notes.Remove(n);
                    JsonInteracter.Write(notes);
                    return Ok(notes);
                }
            }

            return NotFound();
        }

        [HttpPut("all")]
        public IActionResult Update(int id, BNote note)
        {
            Response.Headers.Append("Access-Control-Allow-Origin", "*");
            Response.Headers.Append("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");

            for (int i = 0; i < notes.Count; i++)
            {
                if (notes[i].id == id)
                {
                    notes[i] = note;
                    JsonInteracter.Write(notes);
                    return Ok(notes);
                }
            }

            return NotFound();
        }

        [HttpOptions]
        public IActionResult Optionen()
        {
            Response.Headers.Append("Access-Control-Allow-Origin", "*");
            Response.Headers.Append("Access-Control-Allow-Private-Network", "true");
            //Response.Headers.Append("Access-Control-Allow-Methods", "PUT, OPTIONS, DELETE");

            Response.Headers.Append("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept" );
            Response.Headers.Append("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
            Response.Headers.Append("Access-Control-Allow-Credentials", "true" );
            Response.StatusCode = 200;


            return Ok();
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
