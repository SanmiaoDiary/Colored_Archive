#2025/9/8
#这是CA的mod api
# this is a mod api for Corlored Archive
import pygame
from pathlib import Path
import importlib.util

pygame.init() #初始化pygame

class API():
    def __init__(self, screen):
        self.screen = screen

class Mod():#加载mod的类
    ID = ""
    name = ""
    list = []
    quantity = 0
    def lading_mods(screen):#创建加载mod方法
        print("开始加载mod")
        api = API(screen)
        mods_folder = Path("mods")

        for mod in mods_folder.iterdir():
            if not mods_folder.is_dir():
                continue
            if mods_folder.name == "__pycache__":
                continue
            mod_file = mods_folder / f"mod_folder.name.py"
            if not mod_file.exists():
                print(print(f"[water]:[警告]{mods_folder.name}文件夹缺少 .py文件"))
                continue
            try:
                spec = importlib.util.spec_from_file_location(mods_folder.name, mod_file)
                mod = importlib.util.module_from_spec(spec)
                spec.loader.exec_module(mod)
                if hasattr(mod, "mod_enter"):  # 如果这个mod有“入场券”
                    mod.mod_enter(api)  # 给它喇叭，让它开始干活
                print(f"[water]:[成功]mod{mod.name} ID:{mod.ID} 成功加载")
            except Exception as error_information:
                print(f"[water]:[警告] mod{mod.name} ID:{mod.ID} 出错原因：{error_information}")

        print("[water] 所有装修小队检查完毕！")
        return api