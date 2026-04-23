﻿using BestNote.Models;
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
using System.Text;
using System.IO.Pipes;


namespace BestNote.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotesController : ControllerBase
    {
        // localhost:44367/api/NotesController
        List<BNote> notes = new List<BNote>();
        //private readonly NotesContext _db;
        private readonly FileStorage _fileStorage;


        public NotesController(NotesContext db, FileStorage fileStorage)
        {
            notes = JsonInteracter.Read(_fileStorage.GetFilePath("Notizen.json"));
            _fileStorage = fileStorage;
        }

        [HttpPost]
        public IActionResult CreateNote(BNote2 note)
        {

            BNote newNote = new(notes.Count, note.titel, note.inhalt);
            notes.Add(newNote);
            JsonInteracter.Write(notes, _fileStorage.GetFilePath("Notizen.json"));

            return CreatedAtAction("GetNote", new { id = newNote.id }, newNote);
        }

        [HttpGet("one")]
        public IActionResult GetNote(long id)
        {

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
                bytes = JsonInteracter.GetFileContent(assetPath);
                if(file == "index.html")
                {
                    string fileContents;
                    using (StreamReader reader = new StreamReader(bytes))
                    {
                        fileContents = reader.ReadToEnd();
                    }

                    fileContents = fileContents.Replace("{{PORT}}", HttpContext.Connection.LocalPort.ToString());
                    MemoryStream stream = new MemoryStream();
                    StreamWriter writer = new StreamWriter(stream);
                    writer.Write(fileContents);
                    writer.Flush();
                    stream.Position = 0;
                    return Ok(stream);
                }
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

            foreach (BNote n in notes)
            {
                if(n.id == id)
                {
                    notes.Remove(n);
                    JsonInteracter.Write(notes, _fileStorage.GetFilePath("Notizen.json"));
                    return Ok(notes);
                }
            }

            return NotFound();
        }

        [HttpPut("{id}")]
        public IActionResult Update(int id, BNote note)
        {

            for (int i = 0; i < notes.Count; i++)
            {
                if (notes[i].id == id)
                {
                    notes[i] = note;
                    JsonInteracter.Write(notes, _fileStorage.GetFilePath("Notizen.json"));
                    return Ok(notes);
                }
            }

            return NotFound();
        }
    }


    public class FileStorage
    {
        private readonly string _dataDir;

        public FileStorage(IConfiguration config)
        {
            _dataDir = config["Data:Directory"];
            Directory.CreateDirectory(_dataDir);
        }

        public string GetFilePath(string fileName)
        {
            return Path.Combine(_dataDir, fileName);
        }
    }

        public class JsonInteracter
        {
            public static List<BNote> Read(string path)
            {
                string jsonString = File.ReadAllText(path);
                JsonSerializerOptions options = new JsonSerializerOptions
                {
                    IncludeFields = true
                };

                List<BNote>? notize = JsonSerializer.Deserialize<List<BNote>>(jsonString, options);
                return notize;
            }

        public static void Write(List<BNote> notes, string path)
        {
            string fileName = "Notizen.json";
            JsonSerializerOptions options = new JsonSerializerOptions
            {
                WriteIndented = true
            };
            var json = JsonSerializer.Serialize(notes, options);
            File.WriteAllText(fileName, json);
        }

        public static FileStream GetFileContent(string file)
        {
            try
            {
                return File.OpenRead("wwwroot/flutter_web_app/" + file);
            }
            catch (Exception ex) { 
                Console.WriteLine(ex.Message);
            }
            return null;
        }

        public static string GetMediaType(string file)
        {
            var inspector = new FileFormatInspector();
            FileStream stream = File.OpenRead("wwwroot/flutter_web_app/" + file);
            var format = inspector.DetermineFileFormat(stream);

            stream.Close();

            if (format == null)
            {
                var provider = new FileExtensionContentTypeProvider();
                string providerContentType = "";
                if (provider.TryGetContentType("wwwroot/flutter_web_app/" + file, out providerContentType))
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

