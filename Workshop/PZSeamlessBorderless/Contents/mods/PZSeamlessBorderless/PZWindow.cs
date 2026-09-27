using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Text;

public static class PZSeamlessWindow
{
    [StructLayout(LayoutKind.Sequential)]
    public struct Rect { public int Left, Top, Right, Bottom; }
    [StructLayout(LayoutKind.Sequential)]
    public struct MonitorInfo { public uint Size; public Rect Monitor, Work; public uint Flags; }
    public sealed class State
    {
        public Rect Monitor, Window, Client;
        public long Style;
        public int Width { get { return Monitor.Right - Monitor.Left; } }
        public int Height { get { return Monitor.Bottom - Monitor.Top; } }
        public bool Borderless { get { return (Style & 0x00C40000L) == 0; } }
        public bool FitsScreen { get { return Borderless && Client.Right == Width && Client.Bottom == Height; } }
        public bool Applied { get { return Borderless && Window.Left == Monitor.Left - 1 && Window.Top == Monitor.Top - 1 && Window.Right == Monitor.Right + 1 && Window.Bottom == Monitor.Bottom + 1; } }
        public override string ToString()
        {
            return String.Format("window={0},{1} {2}x{3}; client={4}x{5}; monitor={6}x{7}; borderless={8}", Window.Left, Window.Top, Window.Right-Window.Left, Window.Bottom-Window.Top, Client.Right, Client.Bottom, Width, Height, Borderless);
        }
    }
    [DllImport("user32.dll")] private static extern bool SetProcessDpiAwarenessContext(IntPtr context);
    [DllImport("user32.dll")] private static extern IntPtr MonitorFromWindow(IntPtr window, uint flags);
    [DllImport("user32.dll", SetLastError=true)] private static extern bool GetMonitorInfoW(IntPtr monitor, ref MonitorInfo info);
    [DllImport("user32.dll", SetLastError=true)] private static extern bool GetWindowRect(IntPtr window, out Rect rect);
    [DllImport("user32.dll", SetLastError=true)] private static extern bool GetClientRect(IntPtr window, out Rect rect);
    [DllImport("user32.dll", EntryPoint="GetWindowLongPtrW")] private static extern IntPtr GetWindowLongPtr(IntPtr window, int index);
    [DllImport("user32.dll")] public static extern bool IsIconic(IntPtr window);
    [DllImport("user32.dll", SetLastError=true)] private static extern bool SetWindowPos(IntPtr window, IntPtr after, int x, int y, int width, int height, uint flags);

    public static void Initialize() { SetProcessDpiAwarenessContext(new IntPtr(-4)); }
    public static State Read(IntPtr window)
    {
        var info = new MonitorInfo { Size=(uint)Marshal.SizeOf(typeof(MonitorInfo)) };
        Rect outer, client;
        if (!GetMonitorInfoW(MonitorFromWindow(window,2),ref info) || !GetWindowRect(window,out outer) || !GetClientRect(window,out client))
            throw new Win32Exception(Marshal.GetLastWin32Error());
        return new State { Monitor=info.Monitor, Window=outer, Client=client, Style=GetWindowLongPtr(window,-16).ToInt64() };
    }
    public static void Place(IntPtr window, State state, int overscan)
    {
        if (!SetWindowPos(window,IntPtr.Zero,state.Monitor.Left-overscan,state.Monitor.Top-overscan,state.Width+2*overscan,state.Height+2*overscan,0x0004|0x0010))
            throw new Win32Exception(Marshal.GetLastWin32Error());
    }
    // Windows CRT argument quoting. Game arguments never pass through cmd.exe.
    public static string QuoteArgument(string value)
    {
        var result = new StringBuilder("\"");
        int slashes = 0;
        foreach (char c in value)
        {
            if (c == '\\') { slashes++; continue; }
            if (c == '"') { result.Append('\\',slashes*2+1).Append('"'); }
            else { result.Append('\\',slashes).Append(c); }
            slashes=0;
        }
        return result.Append('\\',slashes*2).Append('"').ToString();
    }
}
