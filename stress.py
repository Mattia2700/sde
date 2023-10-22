import multiprocessing
import os
import sys


def start():
    print("Starting stress test...")
    # get cores number
    cores = os.cpu_count()
    # create processes
    with open(os.devnull, "w") as devnull:
        sys.stderr = devnull
        for _ in range(cores):
            # send stderr to devnull
            p = multiprocessing.Process(target=stress_test)
            p.start()


def stress_test():
    while True:
        pass


if __name__ == "__main__":
    start()
