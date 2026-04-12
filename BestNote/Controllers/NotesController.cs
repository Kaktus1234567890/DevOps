using BestNote.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualBasic;
using System.Net.Http.Headers;
using System.Text.Json;
using System.Text.Json.Serialization;
using static System.Runtime.InteropServices.JavaScript.JSType;
using System.IO;
using FileSignatures;
using FileSignatures.Formats;
using Microsoft.AspNetCore.StaticFiles;


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
            //Response.Headers.Append("Access-Control-Allow-Origin", "*");
            //Response.Headers.Append("Access-Control-Allow-Methods", "PUT, OPTIONS, DELETE");

            BNote newNote = new(notes.Count, note.titel, note.inhalt);
            notes.Add(newNote);
            JsonInteracter.Write(notes);

            return CreatedAtAction("GetNote", new { id = newNote.id }, newNote);
        }

        [HttpGet("one")]
        public IActionResult GetNote(long id)
        {
            //Response.Headers.Append("Access-Control-Allow-Origin", "*");
            //Response.Headers.Append("Access-Control-Allow-Methods", "PUT, OPTIONS, DELETE");

            BNote note;
            foreach (BNote n in notes)
            {
                if (n.id == id)
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
            //Response.Headers.Append("Access-Control-Allow-Origin", "*");
            //Response.Headers.Append("Access-Control-Allow-Methods", "PUT, OPTIONS, DELETE");
            return Ok(notes);
        }

        [HttpGet("{*file}", Order = 999)]
        public IActionResult GetAll(string file = null)
        {

            if (file == null || file == "")
            {
                file = "index.html";
            } 

            string assetPath = file;

            string m = JsonInteracter.GetMediaType(assetPath);
            Response.Headers.Append("Content-Type", m);

            FileStream bytes = null;
            
            try
            {
                bytes = JsonInteracter.GetAllStuff(assetPath);
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception: " + e.Message);
            }

            Response.Headers.Append("Content-Length", (bytes.Length - 1).ToString());
            return new FileStreamResult(bytes, m);
        }

        [HttpDelete("{id}")]
        public IActionResult DeleteOne (int id)
        {
            //Response.Headers.Append("Access-Control-Allow-Origin", "*");
            //Response.Headers.Append("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");

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

        [HttpPut("{id}")]
        public IActionResult Update(int id, BNote note)
        {
            //Response.Headers.Append("Access-Control-Allow-Origin", "*");
            //Response.Headers.Append("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");

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
            //Response.Headers.Append("Access-Control-Allow-Origin", "*");
            //Response.Headers.Append("Access-Control-Allow-Private-Network", "true");
            //Response.Headers.Append("Access-Control-Allow-Methods", "PUT, OPTIONS, DELETE");

            //Response.Headers.Append("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept" );
            //Response.Headers.Append("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
            //Response.Headers.Append("Access-Control-Allow-Credentials", "true" );
            //Response.StatusCode = 200;


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

        public static FileStream GetAllStuff(string file)
        {
            return File.OpenRead("Assets/flutter_web_app/" + file);
        }

        public static string GetMediaType(string file)
        {
            var inspector = new FileFormatInspector();
            FileStream stream = File.OpenRead("Assets/flutter_web_app/" + file);
            var format = inspector.DetermineFileFormat(stream);

            stream.Close();

            if (format == null)
            {
                var provider = new FileExtensionContentTypeProvider();
                string providerContentType = "";
                if (provider.TryGetContentType("Assets/flutter_web_app/" + file, out providerContentType))
                {
                    return providerContentType;
                }
                else {

                    return "application/octet-stream";
                }
            }

            string mediaType  = format?.MediaType ?? "application/octet-stream";

            return mediaType;
        }
    }
}
