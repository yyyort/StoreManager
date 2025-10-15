using backend.DTOs;
using backend.Models;

namespace backend.Services.Interfaces
{
    public interface IAuthService
    {
        Task<AuthResponseDto?> LoginAsync(LoginDto loginDto);
        Task<AuthResponseDto> RegisterAsync(RegisterDto registerDto);
        Task<User?> GetUserByIdAsync(Guid userId);
    }
}
