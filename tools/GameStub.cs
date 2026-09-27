using System;
using System.Text;
public static class GameStub {
    public static int Main(string[] args) {
        Console.WriteLine("CWD:" + Convert.ToBase64String(Encoding.UTF8.GetBytes(Environment.CurrentDirectory)));
        Console.WriteLine("ENV:" + Environment.GetEnvironmentVariable("PZ_LAUNCHER_TEST"));
        foreach (string value in args) Console.WriteLine("ARG:" + Convert.ToBase64String(Encoding.UTF8.GetBytes(value)));
        return 7;
    }
}
