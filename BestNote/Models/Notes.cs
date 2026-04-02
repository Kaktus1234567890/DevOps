using System.Text.Json;

namespace BestNote.Models
{
    public class BNote
    {
        public long id { get; set; }
        public string titel { get; set; }
        public string inhalt { get; set; }

        public BNote(long id, string titel, string inhalt)
        {
            this.id = id;
            this.titel = titel;
            this.inhalt = inhalt;
        }

        public void Update(string t = "", string i = ""){
            if(t != ""){
                titel = t;
            }
            if(i != ""){
                inhalt = i;
            }
        }

    }
}
