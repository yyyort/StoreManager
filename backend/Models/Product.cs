using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace backend.Models
{
    public class Product
    {
        [Key]
        public Guid Id { get; set; }

        [Required]
        [StringLength(255)]
        public string Name { get; set; } = string.Empty;

        [Required]
        public int Quantity { get; set; }

        [StringLength(500)]
        public string? Image { get; set; }

        [Required]
        [Column(TypeName = "decimal(18, 2)")]
        public decimal Price { get; set; }

        [Required]
        public Guid UserId { get; set; }

        [Required]
        public Guid StoreId { get; set; }

        [Required]
        public Guid CategoryId { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

        // Navigation properties
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;

        [ForeignKey("StoreId")]
        public virtual Store Store { get; set; } = null!;

        [ForeignKey("CategoryId")]
        public virtual ProductCategory Category { get; set; } = null!;

        public virtual ICollection<Sale> Sales { get; set; } = new List<Sale>();
        public virtual ICollection<Expense> Expenses { get; set; } = new List<Expense>();
    }
}
