import zombie.core.znet.SteamWorkshopItem;
public class ValidateWorkshop {
    public static void main(String[] args) throws Exception {
        zombie.ZomboidFileSystem.instance.base.set(new java.io.File("."));
        SteamWorkshopItem item = new SteamWorkshopItem(args[0]);
        if (!item.readWorkshopTxt()) throw new IllegalStateException("Cannot read workshop.txt");
        String error = item.validateContents();
        System.out.println("VALIDATION=" + error);
        System.out.println("TITLE=" + item.getTitle());
        System.out.println("VISIBILITY=" + item.getVisibility());
        if (error != null) throw new IllegalStateException(error);
    }
}
