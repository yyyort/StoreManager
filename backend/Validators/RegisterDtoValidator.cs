using FluentValidation;
using backend.DTOs;

namespace backend.Validators
{
    public class RegisterDtoValidator : AbstractValidator<RegisterDto>
    {
        public RegisterDtoValidator()
        {
            RuleFor(x => x.Name)
                .NotEmpty().WithMessage("Name is required")
                .MaximumLength(255).WithMessage("Name must not exceed 255 characters");

            RuleFor(x => x.Email)
                .NotEmpty().WithMessage("Email is required")
                .EmailAddress().WithMessage("Invalid email format")
                .MaximumLength(255).WithMessage("Email must not exceed 255 characters");

            RuleFor(x => x.Password)
                .NotEmpty().WithMessage("Password is required")
                .MinimumLength(6).WithMessage("Password must be at least 6 characters")
                .MaximumLength(255).WithMessage("Password must not exceed 255 characters");

            RuleFor(x => x.Avatar)
                .MaximumLength(500).WithMessage("Avatar URL must not exceed 500 characters")
                .When(x => !string.IsNullOrEmpty(x.Avatar));
        }
    }
}
