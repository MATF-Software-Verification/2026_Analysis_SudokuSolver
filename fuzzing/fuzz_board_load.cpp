#include <cstdint>
#include <cstddef>
#include <unistd.h>
#include "Board.h"

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{
    char path[] = "/tmp/fuzz_board_XXXXXX";
    int fd = mkstemp(path);
    if (fd < 0)
        return 0;

    ssize_t written = write(fd, data, size);
    (void)written;
    close(fd);

    Board board;
    board.load(path);

    unlink(path);
    return 0;
}