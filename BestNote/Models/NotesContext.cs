using Microsoft.EntityFrameworkCore;

namespace BestNote.Models
{
    public class NotesContext : DbContext
    {
        public NotesContext(DbContextOptions<NotesContext> options) : base(options) {
        
        }


    public DbSet<BNote> BestNotes { get; set; }

    }
}
